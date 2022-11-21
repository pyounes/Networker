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
  
  /// Request With NWRequest
  /// To be used for the framework
  /// returns response with the model invoked in the caller
  @discardableResult
  func get<Response: Decodable>(
    request: NWRequest,
    response: Response.Type,
    withLoader: Bool,
    completion: @escaping (Swift.Result<Response, Error>) -> Void
  ) -> HTTPClientTask
}
