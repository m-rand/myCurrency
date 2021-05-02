//
//  ExchangeCurrencyProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine


final class ExchangeRateProvider {
  
  private let client: APIClient
  private let request: ExchangeRateRequestProviding
  private let decoder: DecoderProviding<ExchangeRateList>
  private var state: AppState
  private var cancellables = Set<AnyCancellable>()
  
  init(
    client: APIClient,
    request: ExchangeRateRequestProviding,
    decoder: DecoderProviding<ExchangeRateList>,
    state: AppState
  ) {
    self.client = client
    self.request = request
    self.decoder = decoder
    self.state = state
    state.$base // Subscribe to all changes to state.base
      .removeDuplicates()
      .filter { $0 != nil && !$0!.isEmpty } // Filter out empty base codes
      .sink { base in
        self.fetchExchangeCurrency(for: base!, others: [])
      }
      .store(in: &self.cancellables)
  }
}

extension ExchangeRateProvider {  
  func fetchExchangeCurrency(for code: String, others: [String]) {
    let request = request.buildRequest(code, others)
    client.execute(request)
      .print()
      .decode(type: ExchangeRateList.self, decoder: self.decoder)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print("received error: ", error)
          self.state.error = error
        }
      }, receiveValue: { [weak self] list in
        self?.state.exchangeRates.base = list.base
        self?.state.exchangeRates.rates =
          list.rates.keys.reduce(into: [:]) { dict, elem in
            dict[elem] = list.rates[elem]
          }
      })
      .store(in: &self.cancellables)
  }
}
