//
//  ExchangeCurrencyProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine
import SwiftUI

class ExchangeCurrencyProvider: ObservableObject {
  private var state: AppState?
  private var baseToken: AnyCancellable?
  private var exchangeToken: AnyCancellable?
  @Published var exchangeRates = CurrencyExchange(base: "", rates: [:])
  
  func setup(state: AppState) {
    self.state = state
    baseToken = state.$base
      .removeDuplicates()
      .filter{ $0 != nil }
      .sink(receiveCompletion: { _ in },
            receiveValue: { base in
              self.fetchExchangeCurrency(for: base!, others: [])
            })
  }
}

extension ExchangeCurrencyProvider {
  func fetchExchangeCurrency(for code: String, others: [String]) {
    exchangeToken = ExchangeCurrencyClient.request(path: .latestRates, base: code, others: others)
      .mapError({ (error) -> Error in // MARK: TODO
        print(error)
        return error
      })
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [self] in
          self.exchangeRates = $0
      })
  }
}
