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
  
  var urlWithPath: URL {
    let requestURL =  nwRequest.baseURL.appendingPathComponent(nwRequest.path, isDirectory: false)
    
    guard
      let queryItems = nwRequest.query?.map({ URLQueryItem(name: $0, value: $1) }).compactMap({ $0 }),
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
    request.httpMethod = nwRequest.httpMethod.type
    
    // adding general default Headers
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
