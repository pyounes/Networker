//
//  Data+Extension.swift
//  
//
//  Created by Pierre Younes on 14/11/2022.
//

import Foundation

extension Data {
  var prettyJson: String {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: [.mutableLeaves]),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]),
          let prettyPrintedString = String(data: data, encoding:.utf8) else { return "Pretty JSON Error" }
    return prettyPrintedString
  }
}
