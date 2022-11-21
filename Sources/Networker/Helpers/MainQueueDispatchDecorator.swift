//
//  MainQueueDispatchDecorator.swift
//  
//
//  Created by Pierre Younes on 21/11/2022.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
  private let decoratee: T
  
  init(decoratee: T) {
    self.decoratee = decoratee
  }
  
  func dispatch(completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }
    
    completion()
  }
}


extension MainQueueDispatchDecorator: NWActivityIndicator where T == NWActivityIndicator {
  
  func addLoader() {
    self.dispatch { [weak self] in
      self?.decoratee.addLoader()
    }
  }
  
  func removeLoader() {
    self.dispatch { [weak self] in
      self?.decoratee.removeLoader()
    }
  }
}
