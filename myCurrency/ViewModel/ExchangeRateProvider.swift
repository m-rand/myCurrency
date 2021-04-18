//
//  ExchangeCurrencyProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine
import SwiftUI

class ExchangeRateProvider: ObservableObject {
  private var client: ExchangeRateClient?
  private var state: AppState?
  private var baseToken: AnyCancellable?
  private var exchangeToken: AnyCancellable?
  @Published var exchangeRates = CurrencyExchange(base: "", rates: [:])
  
  func setup(state: AppState, client: ExchangeRateClient) {
    self.client = client
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

extension ExchangeRateProvider {
  func fetchExchangeCurrency(for code: String, others: [String]) {
    exchangeToken = client!.request(path: .latestRates, base: code, others: others)
      .receive(on: RunLoop.main)
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
