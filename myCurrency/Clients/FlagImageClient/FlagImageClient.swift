//
//  FlagImageClient.swift
//  myCurrency
//
//  Created by Marcel Baláš on 19.04.2021.
//

import Foundation
import Combine

class FlagImageClient: APIClient {
  typealias T = Data
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    return data as! T
  }
}

extension FlagImageClient {
  func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
    return run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}

