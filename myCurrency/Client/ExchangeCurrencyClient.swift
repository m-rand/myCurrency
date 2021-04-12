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
  
  static func createRequest(path: Path, base: String, others: [String]) -> URLRequest {
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "v6.exchangerate-api.com/v6/"+apiKey
    urlComponents.path = path.rawValue
    urlComponents.queryItems = [
      URLQueryItem(name: "access_key", value: apiKey),
      URLQueryItem(name: "base", value: base),
      URLQueryItem(name: "symbols", value: others.joined(separator: ","))
    ]

    var urlRequest = URLRequest(url: urlComponents.url!)
    urlRequest.httpMethod = "GET"

    return urlRequest
  }
    
  static func request(path: Path, base: String, others: [String]) -> AnyPublisher<CurrencyExchange, Error> {
        
    //let request = createRequest(path: path, base: base, others: others)
    let urlString: String = String(baseUrlString+apiKey+path.rawValue+base)
    let request = URLRequest(url: URL(string: urlString)!)
    print(request)
        
    return client.run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
