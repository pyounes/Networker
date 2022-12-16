import Foundation

public final class Networker: HTTPClient {
  
  private let networkConfigurations: NWSessionConfiguration
  private let logger: NWLogger
  private let activityIndicator: NWActivityIndicator
  private let monitor: NWMonitor
  
  public init(
            networkConfiguration: NWSessionConfiguration,
    logger: NWLogger,
    activityIndicator: NWActivityIndicator,
    monitor: NWMonitor
  ) {
    self.networkConfigurations = networkConfiguration
    self.logger = logger
    self.activityIndicator = MainQueueDispatchDecorator(decoratee: activityIndicator)
    self.monitor = monitor
    
    monitor.startMonitoring()
  }
  
  public init() {
    self.networkConfigurations = NWNDefaultSessionConfiguration()
    self.logger = NWDefaultLogger()
    self.activityIndicator = MainQueueDispatchDecorator(decoratee: NWDefaultActivityIndicator())
    self.monitor = NWDefaultNetworkMonitor()
    
    monitor.startMonitoring()
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
  ) -> HTTPClientTask {
    
    let nwRequest = NWRequestBuilder(request: request)
    
    if withLoader {
      activityIndicator.addLoader()
    }
    
    // Staring Session Execution
    let task = networkConfigurations.session.dataTask(with: nwRequest.urlRequest) { data, urlResponse, error in
      
      self.handleDataTaskResponse(request: nwRequest, response: response, urlResponse: urlResponse, data: data, error: error) { result in
        
          if Thread.isMainThread {
              completion(result)
          } else {
              DispatchQueue.main.async {
                  completion(result)
              }
          }
        
        if withLoader {
          self.activityIndicator.removeLoader()
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
      logger.log(title: "URL", url)
    }
    
    if let headers = request.urlRequest.allHTTPHeaderFields?.description {
      logger.log(title: "HEADERS",  headers)
    }
    
    if let body = request.urlRequest.httpBody {
      logger.log(title: "BODY", body.prettyJson)
    }
    
    do {
      
      if let error = error {
        if monitor.isConnected {
          throw error
        } else {
          throw NWCustomError.noInternet
        }
      }
      
      guard
        let httpURLResponse = urlResponse as? HTTPURLResponse
      else {
        throw NWCustomError.invalidResponse
      }
      
      guard
        request.nwRequest.acceptableStatusCodes.contains(httpURLResponse.statusCode)
      else {
        throw NWCustomError.unacceptableStatusCode(httpURLResponse.statusCode)
      }
      
      // STATUS CODE
      logger.log(title: "STATUS-CODE", httpURLResponse.statusCode.description)
      
      guard
        let data = data
      else {
        throw NWCustomError.emptyData
      }
      
      // Printing JSON
      logger.log(title: "RESPONSE", data.prettyJson)
      
      try handleRawData(data: data) { result in
        completion(result)
      }
      
    } catch let nwCustomError as NWCustomError {
      // Internet Unavailable
      logger.log(title: "NW-CUSTOM-ERROR", nwCustomError.localizedDescription)
      completion(.failure(nwCustomError))
    } catch let decodingError as DecodingError {
      // Decoding Error
      logger.log(title: "NW-ERROR-DECODING", decodingError.debugDescription)
      completion(.failure(decodingError))
    } catch {
      // Unknown Error
      logger.log(title: "NW-ERROR-RESPONSE", error.localizedDescription)
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
  
  // MARK: - Deinit
  deinit {
    monitor.stopMonitoring()
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
