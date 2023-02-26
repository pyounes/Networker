//
//  NWCustomError.swift
//  
//
//  Created by Pierre Younes on 17/11/2022.
//

import Foundation

public enum NWError: Error {
  case invalidURL
  case noInternet
  case invalidResponse
  case unacceptableStatusCode(Int)
  case emptyData
}

extension NWError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL" // Check NWRequestBuilder
    case .noInternet:
      return "Your Internet connection appears to be offline"
    case .invalidResponse:
      return "Request did not return HttpURLResponse"
    case let .unacceptableStatusCode(receivedCode):
      return "Unacceptable StatusCode received \(receivedCode.description), Check acceptableStatusCodes property in NWRequest"
    case .emptyData:
      return "Empty Data"
    }
  }
}
