//
//  ExchangeRateRequestProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 19.04.2021.
//

import Foundation


protocol ExchangeRateRequestProvider {
  func buildRequest(for base: String, others: [String]) -> URLRequest
}

struct ExchangeRateRequest: ExchangeRateRequestProvider {
  let apiKey: String = "db249d6a9b81d3cdd9620df7"
  let baseUrlString = "https://v6.exchangerate-api.com/v6/"
  let path = "/latest/"
  
  func buildRequest(for base: String, others: [String]) -> URLRequest {
    let urlString: String = String(baseUrlString+apiKey+path+base)
    return URLRequest(url: URL(string: urlString)!)
  }
}
