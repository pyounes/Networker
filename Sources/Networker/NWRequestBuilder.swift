//
//  NWRequestBuilder.swift
//  
//
//  Created by Pierre Younes on 17/11/2022.
//

import Foundation

final class NWRequestBuilder {
  
  let nwRequest: NWRequest
  
  init(request: NWRequest) {
    self.nwRequest = request
  }
  
  private var url: URL {
    
    let baseURLWithPath =  nwRequest.baseURL.appendingPathComponent(nwRequest.path, isDirectory: false)
    
    guard
      let queryItems = nwRequest.query?.compactMapValues({ $0 }).map({ URLQueryItem(name: $0, value: $1) }),
      !queryItems.isEmpty,
      var urlComponents = URLComponents(url: baseURLWithPath, resolvingAgainstBaseURL: true)
    else {
      return baseURLWithPath
    }
    
    urlComponents.queryItems = queryItems
    
    return urlComponents.url ?? baseURLWithPath
  }
  
  
  var urlRequest: URLRequest {
    
    // constructing a URLRequest with The urlWithPath ( with path and query if available )
    var request = URLRequest(url: url)
    
    // adding respective HttpMethod
    request.httpMethod = nwRequest.httpMethod.type
    
    // adding general default Headers 
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // adding default endpointHeader
    nwRequest.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    // adding Token if required
    if nwRequest.withToken {
      request.setValue("Bearer \(nwRequest.token)", forHTTPHeaderField: "Authorization")
    }
    
    // adding additional body Parameters
    if let params = nwRequest.parameters,
       !params.isEmpty,
       let data = try? JSONSerialization.data(withJSONObject: params, options: []) {
      request.httpBody = data
    }
    
    return request
  }
  
}
