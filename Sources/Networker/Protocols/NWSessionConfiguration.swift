//
//  NWSessionConfiguration.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation


public protocol NWSessionConfiguration {
  
  // URLSession
  var urlSession                : URLSession                { get }
  
  // URLSession Configurations
  var urlSessionConfigurations  : URLSessionConfiguration   { get }
}


extension NWSessionConfiguration {
    
  var urlSession: URLSession { URLSession(configuration: urlSessionConfigurations) }
  
  var urlSessionConfigurations: URLSessionConfiguration {
    let config = URLSessionConfiguration.ephemeral
    config.timeoutIntervalForRequest          = 30
    config.timeoutIntervalForResource         = 30
    config.waitsForConnectivity               = true
    return config
  }
  
}
