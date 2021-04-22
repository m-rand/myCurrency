//
//  ExchangeCurrencyProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine
import SwiftUI

class ExchangeRateProvider {
  private var client: APIClient
  private var requestProvider: ExchangeRateRequestProvider
  private var state: AppState
  private var baseToken: AnyCancellable?
  private var exchangeToken: AnyCancellable?
  
  init(
    client: APIClient,
    requestProvider: ExchangeRateRequestProvider,
    state: AppState
  ) {
    self.client = client
    self.requestProvider = requestProvider
    self.state = state
    self.baseToken = state.$base
      .removeDuplicates()
      .filter{ $0 != nil }
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { base in
          self.fetchExchangeCurrency(for: base!, others: [])
      })
  }
}

extension ExchangeRateProvider {
  func fetchExchangeCurrency(for code: String, others: [String]) {
    let request = requestProvider.buildRequest(for: code, others: others)
    exchangeToken = client.execute(request)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let anError):
          print("received error: ", anError)
        }
      }, receiveValue: {
        self.state.exchangeRates = $0
      })
  }
}
