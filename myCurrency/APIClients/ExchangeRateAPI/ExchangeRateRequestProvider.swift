//
//  ExchangeRateRequestProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 19.04.2021.
//

import Foundation


struct ExchangeRateRequestProviding {
  var buildRequest: (_ base: String, _ others: [String]) -> URLRequest
}

extension ExchangeRateRequestProviding {
  
  // MARK: - release implementation
  public static var release = Self(
    buildRequest: { base, others in
      let apiKey: String = "db249d6a9b81d3cdd9620df7"
      let baseUrlString = "https://v6.exchangerate-api.com/v6/"
      let path = "/latest/"
      let urlString: String = String(baseUrlString+apiKey+path+base)
      return URLRequest(url: URL(string: urlString)!)
    }
  )
  
  // MARK: - failing
  #if DEBUG
  public static let failing = Self(
    buildRequest: { base, others in
      let url = URL(string: "\\\\")!
      return URLRequest(url: url)
    }
  )
  #endif
}
