//
//  CurrencyRateProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 18.04.2021.
//


import Foundation
import Combine

enum ExchangeRateProviderError : Error {
  case abstractMethod
  
  public var errorDescription: String? {
    switch self {
      case .abstractMethod:
        return "Calling an abstract method on ExchangeRateProvider."
    }
  }
}

struct ExchangeRates {
  var base: String
  var rates: [String: Double]
}

class ExchangeRateProvider: ObservableObject {
  @Published var exchangeRates = ExchangeRates(base: "", rates: [:])
  
  func fetchCurrencyRates(for base: String, others: [Currency]) -> Future<ExchangeRates, Error> {
    Future { promise in
      promise(.failure(ExchangeRateProviderError.abstractMethod))
    }
  }
}
