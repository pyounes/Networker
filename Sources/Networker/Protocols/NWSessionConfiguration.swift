//
//  NWSessionConfiguration.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation


public protocol NWSessionConfiguration {
  
  // URLSession
  var session: URLSession { get }
  
  // URLSession Configurations
  var sessionConfigurations: URLSessionConfiguration { get }
}


public extension NWSessionConfiguration {
  
  var session: URLSession { URLSession(configuration: sessionConfigurations) }
  
  var sessionConfigurations: URLSessionConfiguration {
    let config = URLSessionConfiguration.ephemeral
    config.timeoutIntervalForRequest          = 30
    config.timeoutIntervalForResource         = 30
    config.waitsForConnectivity               = true
    return config
  }
  
}
