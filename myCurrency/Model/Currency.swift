//
//  Currency.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation


struct Currency: Decodable, Encodable, Equatable, Hashable {

  var name: String
  var code: String
  var symbol: String
  var value: Double = Double.nan
  var isSelected: Bool = false
  var isBase: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case code, name, symbol
  }
  
  static func == (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.code == rhs.code && lhs.isBase == rhs.isBase
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(code)
    hasher.combine(isBase)
  }
}
