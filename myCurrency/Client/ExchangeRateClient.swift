//
//  ExchangeRateClient.swift
//  myCurrency
//
//  Created by Marcel Baláš on 18.04.2021.
//

import Foundation
import Combine

class ExchangeRateClient: Client {
  
  let apiKey: String = "db249d6a9b81d3cdd9620df7"
  let baseUrlString = "https://v6.exchangerate-api.com/v6/"
  
  enum Path: String {
    case latestRates = "/latest/"
  }
}

extension ExchangeRateClient {
  func request(path: Path, base: String, others: [String]) -> AnyPublisher<CurrencyExchange, Error> {
    
    let urlString: String = String(baseUrlString+apiKey+path.rawValue+base)
    let request = URLRequest(url: URL(string: urlString)!)
    print(request)
    
    return run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}


