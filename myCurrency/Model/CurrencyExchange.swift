//
//  CurrencyExchange.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation

struct CurrencyExchange: Decodable {
  var base: String
  var rates: [String: Double]
  
  enum CodingKeys: String, CodingKey {
    case base = "base_code"
    case rates = "conversion_rates"
  }
}
