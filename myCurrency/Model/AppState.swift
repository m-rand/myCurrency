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
      if newValue.filter({ $0.isSelected }).contains(where: { $0.code == base }) == false {
        base = ""
      }
    }
  }
  @Published var base: String? // contains code of currency selected as a base
  @Published var hasError = false
  @Published var exchangeRates = ExchangeRates(base: "", rates: [:])
  var error: Error? {
    willSet {
      hasError = newValue != nil
    }
  }
}
