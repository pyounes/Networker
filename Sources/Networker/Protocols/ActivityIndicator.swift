//
//  ActivityIndicator.swift
//  
//
//  Created by Pierre Younes on 14/11/2022.
//

import Foundation

public protocol ActivityIndicator {
  func addLoader(withBackground: Bool)
  func removeLoader()
}
