//
//  Data+Extension.swift
//  
//
//  Created by Pierre Younes on 14/11/2022.
//

import Foundation

extension Data {
  var asJSON: String {
    guard
      let object = try? JSONSerialization.jsonObject(with: self, options: [.mutableLeaves]),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]),
      let jsonString = String(data: data, encoding: .utf8)
      else {
        return String(decoding: self, as: UTF8.self)
    }
    return jsonString
  }
}
