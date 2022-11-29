//
//  NWMonitor.swift
//  
//
//  Created by Pierre Younes on 21/11/2022.
//

import Network

public protocol NWMonitor {
  var isConnected: Bool { get }
  
  func startMonitoring()
  func stopMonitoring()
}


final class NWDefaultNetworkMonitor: NWMonitor {
  
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  
  public private(set) var isConnected: Bool = false
  
  init() {
    monitor = NWPathMonitor()
  }
  
  public func startMonitoring() {
    monitor.start(queue: queue)
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
      print("isConnected: \(path.status)")
      
      if !(path.status == .satisfied) { }
      
    }
  }
  
  public func stopMonitoring() {
    monitor.cancel()
  }
}
