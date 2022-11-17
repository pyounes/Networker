//
//  NWMonitor.swift
//  
//
//  Created by Pierre Younes on 17/11/2022.
//

import Network

final class NWMonitor {
  static let shared = NWMonitor()
  
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
      
      if !(path.status == .satisfied) {
        //                DispatchQueue.main.async {
        //                    if let vc = UIApplication.topViewController() {
        //                        vc.showAlert(alertText: "Error", alertMessage: "Your Internet connection appears to be offline")
        //                    }
        //                }
      }
      
    }
  }
  
  public func stopMonitoring() {
    monitor.cancel()
  }
}
