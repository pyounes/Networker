//
//  NWCustomError.swift
//  
//
//  Created by Pierre Younes on 17/11/2022.
//

import Foundation

public enum NWCustomError: Error {
  case invalidURL
  case serverDown
  case noInternet
  case unauthorized
  case sessionExpired
  case emptyData
  case authorizationError
  case endPointServerDown
  case unacceptableStatusCode(Int)
  case invalidResponse
}

extension NWCustomError: LocalizedError {
  
  var localizedDescription: String {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .serverDown:
      return "Server or Endpoint Unavailable"
    case .noInternet:
      return "Your Internet connection appears to be offline"
    case .unauthorized:
      return "Unauthorized Access"
    case .sessionExpired:
      return "Session Expired"
    case .authorizationError:
      return "URL Path Not Found"
    case .endPointServerDown:
      return "Endpoint Server Down"
    case .emptyData:
      return "Empty Data"
    case let .unacceptableStatusCode(receivedCode):
      return "Unacceptable StatusCode received \(receivedCode.description), Check acceptableStatusCodes property in NWRequest"
    case .invalidResponse:
      return "Request did not return HttpURLResponse"
    }
  }
}
