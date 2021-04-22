//
//  DataModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine

class AppState: ObservableObject {
  @Published var allCurrencies = [Currency]() {
    willSet {
      let filtered = newValue.filter{ $0.isSelected }
      if filtered.isEmpty || !filtered.contains(where: { $0.code == base }) {
        base = ""
      }
    }
  }
  @Published var base: String? // contains code of currency selected as a base
  @Published var hasError = false
  @Published var exchangeRates = CurrencyExchange(base: "", rates: [:])
  var error: Error? {
    willSet {
      hasError = newValue != nil
    }
  }
}
