//
//  Logger.swift
//  
//
//  Created by Pierre Younes on 15/11/2022.
//

import Foundation

public protocol Logger {
  func log(title: String, _ description: String)
}


private extension Logger {
  func log(title: String, _ description: String) {
#if DEBUG
    print("""
    ▼-------\(title)--------▼
    \(description)
    ▲-------\(title)--------▲
    
    """)
#endif
  }
}
