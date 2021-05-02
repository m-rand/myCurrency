//
//  Decoder.swift
//  myCurrency
//
//  Created by Marcel Baláš on 28.04.2021.
//

import Foundation
import Combine

enum DecoderError: Error {
  case invalidData
}

struct DecoderProviding<T>: TopLevelDecoder {
  typealias Input = Data
  typealias _T = T
  
  let decoder: (_ type: T.Type, _ from: Data) throws -> T
  
  func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
    return try decoder(type as! Self._T.Type, from) as! T
  }
}
