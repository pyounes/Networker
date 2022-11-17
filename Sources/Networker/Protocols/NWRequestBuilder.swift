//
//  NWRequestBuilder.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation

public protocol NWRequestBuilder {
  var baseURL               : URL                     { get }
  var path                  : String                  { get }
  var httpMethod            : NWMethod                { get }
  var headers               : [String: String]?       { get }
  var query                 : [String: String]?       { get }
  var parameters            : [String: Any]?          { get }
  var withToken             : Bool                    { get }
  var token                 : String                  { get }
  
  // Acceptable Status Codes
  var acceptableStatusCodes : ClosedRange<Int>        { get }
}

protocol NWRequestBuilderHelper: NWRequestBuilder {
  var urlWithPath           : URL                     { get }
  var urlRequest            : URLRequest              { get }
}


extension NWRequestBuilderHelper {
  
  var acceptableStatusCodes: ClosedRange<Int> { 200...299 }
  
  
  var urlWithPath: URL {
    let requestURL =  baseURL.appendingPathComponent(path, isDirectory: false)
    
    guard
      let queryItems = query?.map({ URLQueryItem(name: $0, value: $1) }),
      !queryItems.isEmpty,
      var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
    else {
      return requestURL
    }
    
    urlComponents.queryItems = queryItems
    
    guard let constructedURL = urlComponents.url else { return requestURL }
    
    return constructedURL
  }

  
  var urlRequest: URLRequest {
    
    // constructing a URLRequest with The urlWithPath ( with path and query if available )
    var request = URLRequest(url: urlWithPath)
    
    // adding respective HttpMethod
    request.httpMethod = httpMethod.type
    
    // adding general default Headers
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // adding default endpointHeader
    headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    // adding Token if required
    if withToken {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    // adding additional body Parameters
    if let params = parameters,
       !params.isEmpty,
       let data = try? JSONSerialization.data(withJSONObject: params, options: []) {
      request.httpBody = data
    }
    
    return request
  }
  
}

