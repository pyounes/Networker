import Foundation

public enum NWNetworkerType {
  case `default`
  case simple
}

public final class Networker: HTTPClient {
  
  private let networkConfigurations: NWSessionConfiguration
  private let logger: NWLogger?
  private let activityIndicator: NWActivityIndicator?
  private let monitor: NWMonitor?
  
  public init(
    networkConfiguration: NWSessionConfiguration,
    logger: NWLogger,
    activityIndicator: NWActivityIndicator,
    monitor: NWMonitor
  ) {
    self.networkConfigurations = networkConfiguration
    self.logger = logger
    self.activityIndicator = activityIndicator
    self.monitor = monitor
  }
  
  public init(
    logger: NWLogger,
    activityIndicator: NWActivityIndicator,
    monitor: NWMonitor
  ) {
    self.networkConfigurations = NWNDefaultSessionConfiguration()
    self.logger = logger
    self.activityIndicator = activityIndicator
    self.monitor = monitor
  }
  
  public init(
    activityIndicator: NWActivityIndicator,
    monitor: NWMonitor
  ) {
    self.networkConfigurations = NWNDefaultSessionConfiguration()
    self.logger = NWDefaultLogger()
    self.activityIndicator = activityIndicator
    self.monitor = monitor
  }
  
  public init() {
    self.networkConfigurations = NWNDefaultSessionConfiguration()
    self.logger = NWDefaultLogger()
    self.activityIndicator = nil
    self.monitor = nil
  }
  
  public init(type: NWNetworkerType) {
    self.networkConfigurations = NWNDefaultSessionConfiguration()
    self.logger = type == .default ? NWDefaultLogger() : nil
    self.activityIndicator = nil
    self.monitor = type == .default ? NWDefaultNetworkMonitor() : nil
  }
  
  /// Generic Api Call
  /// - Parameters:
  ///   - request: NWRequest - Request should conform to `NWRequest` Protocol
  ///   - response: Any Object Conforming to `Codable`
  ///   - withLoader: Bool, whether a Loading indicator should be triggered on api call
  ///   - completion: Decoded Response if .success, Error if .failure
  /// - Returns: HTTPClientTask, Return the wrapper call with the ability to cancel it
  @discardableResult
  public func get<Response: Decodable>(
    request: NWRequest,
    response: Response.Type,
    withLoader: Bool = false,
    completion: @escaping (Result<Response, Error>) -> Void
  ) -> HTTPClientTask? {
    
    guard
      let nwRequest = NWRequestBuilder(request: request)
    else {
      DispatchQueue.main.async {
        completion(.failure(NWError.invalidURL))
      }
      return nil
    }
    
    if withLoader {
      activityIndicator?.addLoader()
    }
    
    // Staring Session Execution
    let task = networkConfigurations.session.dataTask(with: nwRequest.urlRequest) { data, urlResponse, error in
      
      self.handleDataTaskResponse(request: nwRequest,
                                  response: response,
                                  urlResponse: urlResponse,
                                  data: data,
                                  error: error)
      { result in
        
        DispatchQueue.main.async {
          completion(result)
        }
        
        if withLoader {
          self.activityIndicator?.removeLoader()
        }
      }
      
    }
    task.resume()
    return URLSessionTaskWrapper(wrapped: task)
  }
  
  
  /// Handle Data Task Response with a completion of Result<Response, Error>
  private func handleDataTaskResponse<Response: Decodable>(
    request: NWRequestBuilder,
    response: Response.Type,
    urlResponse: URLResponse?,
    data: Data?,
    error: Error?,
    completion: @escaping (Swift.Result<Response, Error>) -> Void
  ) {
    
    if let url = request.urlRequest.url?.absoluteString {
      logger?.log(title: "URL", url)
    }
    
    if let headers = request.urlRequest.allHTTPHeaderFields?.description {
      logger?.log(title: "HEADERS",  headers)
    }
    
    if let body = request.urlRequest.httpBody {
      logger?.log(title: "BODY", body.asJSON)
    }
    
    do {
      
      if let error = error {
        if let monitor = monitor {
          if monitor.isConnected {
            throw error
          } else {
            throw NWError.noInternet
          }
        } else {
          throw error
        }
      }
      
      guard
        let httpURLResponse = urlResponse as? HTTPURLResponse else {
        throw NWError.invalidResponse
      }
      
      // STATUS CODE
      logger?.log(title: "STATUS-CODE", httpURLResponse.statusCode.description)
      
      guard
        let data = data,
        !data.isEmpty
      else {
        throw NWError.emptyData
      }
      
      // Printing JSON
      logger?.log(title: "RESPONSE", data.asJSON)
      
      guard request.nwRequest.acceptableStatusCodes.contains(httpURLResponse.statusCode) else {
        throw NWError.unacceptableStatusCode(httpURLResponse.statusCode)
      }
      
      try handleRawData(data: data) { result in
        completion(result)
      }
      
    } catch let nwError as NWError {
      logger?.log(title: "NW-ERROR", nwError.errorDescription!)
      completion(.failure(nwError))
    } catch let decodingError as DecodingError {
      // Decoding Error
      logger?.log(title: "NW-DECODING-ERROR", decodingError.debugDescription)
      completion(.failure(decodingError))
    } catch {
      // Unknown Error
      logger?.log(title: "NW-RESPONSE-ERROR", error.localizedDescription)
      completion(.failure(error))
    }
  }
  
  
  private func handleRawData<Response: Decodable>(
    data: Data,
    completion: @escaping (Swift.Result<Response, Error>) -> Void
  ) throws {
    // check if the ResponseType Is Data so to return raw Data Instead of trying to Decode to an Object
    if let data = data as? Response {
      completion(.success(data))
    } else {
      do {
        let result = try JSONDecoder().decode(Response.self, from: data)
        completion(.success(result))
      }
    }
  }

}


private extension Networker {
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  private struct URLSessionTaskWrapper: HTTPClientTask {
    let wrapped: URLSessionTask
    
    func cancel() {
      wrapped.cancel()
    }
  }
  
}

