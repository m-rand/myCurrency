//
//  FlagImageDecoder.swift
//  myCurrency
//
//  Created by Marcel Baláš on 27.04.2021.
//

import Foundation


extension DecoderProviding where T == Data {
  
  // MARK: - release implementation
  static let release = Self(
    decoder: { type, from in
      return from // Return data just as it is.
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
