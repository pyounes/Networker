import Foundation

public final class Networker {
  
  private let logger: NWLogger
  private let activityIndicator: NWActivityIndicator
  private let session: NWSessionConfiguration
  
  public init(
    session: NWSessionConfiguration,
    logger: NWLogger,
    activityIndicator: NWActivityIndicator
  ) {
    self.logger = logger
    self.activityIndicator = activityIndicator
    self.session = session
  }
  
  
  /// Without Parameters of type RequestParams
  public func taskHandler<Response: Decodable>(
    request: NWRequest,
    response: Response.Type,
    withLoader: Bool = false,
    completion: @escaping (Result<Response, Error>) -> Void
  ) {
    
    let nwRequest = NWRequestBuilder(request: request)
    
    if withLoader {
      activityIndicator.addLoader()
    }
    
    // Staring Session Execution // - TODO: should check if [weak self] should be used here
    let task = session.session.dataTask(with: nwRequest.urlRequest) { data, urlResponse, error in
      
      self.handleDataTaskResponse(request: nwRequest, response: response, urlResponse: urlResponse, data: data, error: error) { result in
        DispatchQueue.main.async {
          completion(result)
        }
        
        if withLoader {
          self.activityIndicator.removeLoader()
        }
      }
    }
    
    task.resume()
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
        if NWMonitor.shared.isConnected {
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
        throw NWCustomError.invalidStatusCode(httpURLResponse.statusCode)
      }
      
      guard
        let data = data
      else {
        throw NWCustomError.emptyData
      }
      
      // STATUS CODE
      logger.log(title: "STATUS-CODE", httpURLResponse.statusCode.description)
      
      // Printing JSON
      logger.log(title: "RESPONSE", data.prettyJson)
      
      try handleRawData(data: data) { result in
        completion(result)
      }
      
    } catch NWCustomError.noInternet {
      // Internet Unavailable
      logger.log(title: "NO-INTERNET", NWCustomError.noInternet.localizedDescription)
      completion(.failure(NWCustomError.noInternet))
    } catch let decodingError as DecodingError {
      // Decoding Error
      logger.log(title: "DECODING-ERROR", decodingError.debugDescription)
      completion(.failure(decodingError))
    } catch {
      // Unknown Error
      logger.log(title: "RESPONSE", error.localizedDescription)
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
