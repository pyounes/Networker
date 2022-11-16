//
//  DecodingError+Extension.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation

extension DecodingError {
  
  var errorDescription: String? {
    switch self {
    case let .typeMismatch(type, context):
      return "-- Type '\(type)' \n-- Mismatch: \(context.debugDescription) \n-- CodingPath: \(context.codingPath)"
    case let .valueNotFound(type, context):
      return "-- Type '\(type)' \n-- ValueNotFound: \(context.debugDescription) \n-- CodingPath: \(context.codingPath)"
    case let .keyNotFound(type, context):
      return "-- Type '\(type)' \n-- KeyNotFound: \(context.debugDescription) \n-- CodingPath: \(context.codingPath)"
    case let .dataCorrupted(context):
      return "-- CorruptedData: \(context.debugDescription) \n-- CodingPath: \(context.codingPath)"
    @unknown default:
      return "Unknown Decoding Error"
    }
  }
}
