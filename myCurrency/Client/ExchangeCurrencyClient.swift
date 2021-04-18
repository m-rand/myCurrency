//
//  ExchangeCurrencyClient.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine

struct ExchangeCurrencyClient {
  static let client = Client()
  static let apiKey: String = "db249d6a9b81d3cdd9620df7"
  static let baseUrlString = "https://v6.exchangerate-api.com/v6/"
}

enum Path: String {
    case latestRates = "/latest/"
}


extension ExchangeCurrencyClient {
  
  static func request(path: Path, base: String, others: [String]) -> AnyPublisher<CurrencyExchange, Error> {
        
    let urlString: String = String(baseUrlString+apiKey+path.rawValue+base)
    let request = URLRequest(url: URL(string: urlString)!)
    print(request)
        
    return client.run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
