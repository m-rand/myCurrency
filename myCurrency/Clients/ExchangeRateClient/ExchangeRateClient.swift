//
//  ExchangeRateClient.swift
//  myCurrency
//
//  Created by Marcel Baláš on 18.04.2021.
//

import Foundation
import Combine

class ExchangeRateClient: APIClient {
  typealias T = CurrencyExchange
}

extension ExchangeRateClient {
  func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
    return run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
