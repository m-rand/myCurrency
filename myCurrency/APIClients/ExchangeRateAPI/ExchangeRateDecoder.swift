//
//  ExchangeRateDecoder.swift
//  myCurrency
//
//  Created by Marcel Baláš on 27.04.2021.
//

import Foundation
import Combine

struct ExchangeRateDecoder: TopLevelDecoder {
  typealias Input = Data
  typealias T = CurrencyExchange
  
  var decoder: (_ type: T.Type, _ from: Data) throws -> T
  
  func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
    return try decoder(type as! ExchangeRateDecoder.T.Type, from) as! T
  }
}

extension ExchangeRateDecoder {
  
  // MARK: release implementation
  public static let release = Self(
    decoder: { type, from in
      return try JSONDecoder().decode(type, from: from)
    }
  )
  
  // MARK: failing
  #if DEBUG
  public static let failing = Self(
    decoder: { type, from in
      throw DecoderError.invalidData
    }
  )
  #endif
}
