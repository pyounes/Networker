//
//  NWMonitor.swift
//  
//
//  Created by Pierre Younes on 21/11/2022.
//

import Network

public protocol NWMonitor {
  var isConnected: Bool { get }
}


final class NWDefaultNetworkMonitor: NWMonitor {
  
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  private let logger = NWDefaultLogger()
  
  public private(set) var isConnected: Bool = false
  
  init() {
    monitor = NWPathMonitor()
    
    monitor.start(queue: queue)
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
      self?.logger.log(title: "Default Monitor", "isConnected: \(path.status)")
    }
    
  }
  
  deinit {
    monitor.cancel()
  }
}
