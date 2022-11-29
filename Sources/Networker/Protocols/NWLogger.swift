//
//  NWLogger.swift
//  
//
//  Created by Pierre Younes on 15/11/2022.
//

import Foundation

public protocol NWLogger {
  func log(title: String, _ description: String)
}

final class NWDefaultLogger: NWLogger {
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
