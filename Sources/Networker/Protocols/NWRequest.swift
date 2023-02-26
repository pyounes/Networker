//
//  NWRequestBuilder.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation

public protocol NWMainBaseRequest {
  /// Acceptable Status Codes
  var acceptableStatusCodes : [Int]                   { get }
  var defaultHeaders        : [String: String]?       { get }
  var baseURL               : URL                     { get }
  var token                 : String                  { get }
}

public extension NWMainBaseRequest {
  var acceptableStatusCodes: [Int] { [200] }
  var defaultHeaders: [String: String]? { nil }
  var token: String { "Undefined token computed property in NWRequest" }
}

public protocol NWRequest: NWMainBaseRequest {
  
  var path                  : String                  { get }
  var headers               : [String: String]?       { get }
  var httpMethod            : NWMethod                { get }
  var query                 : [String: String?]?      { get }
  var parameters            : [String: Any]?          { get }
  var withToken             : Bool                    { get }
  
}

// MARK: - Default Implementation

public extension NWRequest {
  var headers: [String: String]? { nil }
  var httpMethod: NWMethod { .get }
  var query: [String: String?]? { nil }
  var parameters: [String: Any]? { nil }
  var withToken: Bool { true }
}
