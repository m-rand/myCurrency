//
//  ExchangeRateDecoder.swift
//  myCurrency
//
//  Created by Marcel Baláš on 27.04.2021.
//

import Foundation
import Combine

struct ExchangeRateList: Decodable {
  var base: String
  var rates: [String : Double]
  
  enum CodingKeys: String, CodingKey {
    case base = "base_code"
    case rates = "conversion_rates"
  }
}

extension DecoderProviding where T == ExchangeRateList {
  
  // MARK: - release implementation
  static let release = Self(
    decoder: { type, from in
      return try JSONDecoder().decode(type, from: from)
    }
  )
  
  // MARK: - failing
  #if DEBUG
  static let failing = Self(
    decoder: { type, from in
      throw DecoderError.invalidData
    }
  )
  #endif
}
