//
//  NWActivityIndicator.swift
//  
//
//  Created by Pierre Younes on 14/11/2022.
//

import Foundation

public protocol NWActivityIndicator {
  func addLoader()
  func removeLoader()
}


public extension NWActivityIndicator {
  func addLoader() { }
  func removeLoader() { }
}
