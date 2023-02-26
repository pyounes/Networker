//
//  NWRequestBuilder.swift
//  
//
//  Created by Pierre Younes on 17/11/2022.
//

import Foundation

final class NWRequestBuilder {
  
  let nwRequest: NWRequest
  private let url: URL
  
  lazy var urlRequest: URLRequest = {
    // constructing a URLRequest with The urlWithPath ( with path and query if available )
    var urlRequest = URLRequest(url: url)
    
    // adding respective HttpMethod
    urlRequest.httpMethod = nwRequest.httpMethod.type
    
    // adding general default Headers
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    // adding defaultRequests Header // headers for all requests provided in `NWMainBaseRequest`
    nwRequest.defaultHeaders?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    // adding additional specific endpointHeaders provided in `NWRequest`
    nwRequest.headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    // adding Token if required
    if nwRequest.withToken {
      urlRequest.setValue("Bearer \(nwRequest.token)", forHTTPHeaderField: "Authorization")
    }
    
    // adding additional body Parameters
    if let params = nwRequest.parameters,
       !params.isEmpty,
       let data = try? JSONSerialization.data(withJSONObject: params, options: []) {
      urlRequest.httpBody = data
    }
    
    return urlRequest
  }()
  
  
  init?(request: NWRequest) {
    self.nwRequest = request
    
    let baseURLWithPath =  request.baseURL.appendingPathComponent(request.path, isDirectory: false)
    
    guard var urlComponents = URLComponents(url: baseURLWithPath, resolvingAgainstBaseURL: true) else { return nil }
    
    if let queryItems = request.query?.compactMapValues({ $0 }).map({ URLQueryItem(name: $0, value: $1) }),
       !queryItems.isEmpty {
      urlComponents.queryItems = queryItems
    }
    
    guard let url = urlComponents.url else { return nil }
    
    self.url = url
  }
  
}

