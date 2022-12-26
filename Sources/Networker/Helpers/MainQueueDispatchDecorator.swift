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
    dispatch { [weak self] in
      self?.decoratee.addLoader()
    }
  }
  
  func removeLoader() {
    dispatch { [weak self] in
      self?.decoratee.removeLoader()
    }
  }
}

// MARK: - Example 
//extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
//  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
//    return decoratee.loadImageData(from: url) { [weak self] result in
//      self?.dispatch { completion(result) }
//    }
//  }
//}
