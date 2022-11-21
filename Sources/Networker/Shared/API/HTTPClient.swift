//
//  HTTPClient.swift
//  
//
//  Created by Pierre Younes on 19/11/2022.
//

import Foundation

public protocol HTTPClientTask {
  func cancel()
}

public protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  @discardableResult
  func get(from url: URL,
           completion: @escaping (Result) -> Void
  ) -> HTTPClientTask
    
    
    /// Request With NWRequest
    /// To be used for the framework
    /// returns response with the model invoked in the caller
    @discardableResult
    func taskHandler<Response: Decodable>(
      request: NWRequest,
      response: Response.Type,
      withLoader: Bool,
      completion: @escaping (Swift.Result<Response, Error>) -> Void
    ) -> HTTPClientTask
}
