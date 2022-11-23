//
//  NWRequestBuilder.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation

public protocol NWRequest {
  
  /// Acceptable Status Codes
  var acceptableStatusCodes : ClosedRange<Int>        { get }
  
  var baseURL               : URL                     { get }
  var path                  : String                  { get }
  var headers               : [String: String]?       { get }
  var httpMethod            : NWMethod                { get }
  var query                 : [String: String?]?      { get }
  var parameters            : [String: Any]?          { get }
  var withToken             : Bool                    { get }
  var token                 : String                  { get }
  
}

// MARK: - Default Implementation

public extension NWRequest {
  var acceptableStatusCodes: ClosedRange<Int> { 200...299 }
  var headers: [String: String]? { nil }
  var httpMethod: NWMethod { NWMethod.get }
  var query: [String: String?]? { nil }
  var parameters: [String: Any]? { nil }
  var withToken: Bool { false }
  var token: String { "Undefined token computed property in NWRequest" }
}
