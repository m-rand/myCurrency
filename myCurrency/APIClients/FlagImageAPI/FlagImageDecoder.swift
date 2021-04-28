//
//  FlagImageDecoder.swift
//  myCurrency
//
//  Created by Marcel Baláš on 27.04.2021.
//

import Foundation
import Combine


struct FlagImageDecoder: TopLevelDecoder {
  typealias Input = Data
  typealias T = Data
  
  var decoder: (_ type: T.Type, _ from: Data) throws -> T
  
  func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
    return try decoder(type as! FlagImageDecoder.T.Type, from) as! T
  }
}

extension FlagImageDecoder {
  
  // MARK: release implementation
  public static let release = Self(
    decoder: { type, from in
      return from // Return data just as it is.
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
