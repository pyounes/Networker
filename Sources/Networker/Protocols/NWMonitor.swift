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


public extension NWMonitor {
  
  var isConnected: Bool {
    return NetworkMonitor.shared.isConnected
  }
  
  func startMonitoring() {
    NetworkMonitor.shared.startMonitoring()
  }
  
  func stopMonitoring() {
    NetworkMonitor.shared.stopMonitoring()
  }
}



final class NetworkMonitor {
  static let shared = NetworkMonitor()
  
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  
  public private(set) var isConnected: Bool = false
  
  private init() {
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
