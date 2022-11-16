//
//  NWMethod.swift
//  
//
//  Created by Pierre Younes on 16/11/2022.
//

import Foundation

public enum NWMethod: String {
  
  case get
  case post
  case put
  case delete
  
  var type: String { rawValue.uppercased() }
  
}
