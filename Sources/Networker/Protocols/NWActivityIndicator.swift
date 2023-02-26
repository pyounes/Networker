//
//  NWActivityIndicator.swift
//  
//
//  Created by Pierre Younes on 14/11/2022.
//

public protocol NWActivityIndicator {
  func addLoader()
  func removeLoader()
}


#if canImport(UIKit)
import UIKit

public final class NWDefaultActivityIndicator: NWActivityIndicator {
  
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
  private let blur: UIColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
  
  
  func addLoader() {
    removeLoader()
    
    view.backgroundColor = withBackground ? blur : .clear
    activityIndicator.center = view.center
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    
    guard let window = UIApplication.shared.windows.last else { return }
    
    window.addSubview(view)
  }
  
  func removeLoader() {
    view.removeFromSuperview()
    activityIndicator.stopAnimating()
  }
  
}

#endif
