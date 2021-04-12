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
  private var dataModel: DataModel
  private var currenciesToken: AnyCancellable?
  private var exchangeToken: AnyCancellable?
  @Published var exchangeRates = CurrencyExchange(base: "", rates: [:])
  
  init(dataModel: DataModel) {
    self.dataModel = dataModel
    
    /// Subscribe to changes on dataModel.myCurrencies and filter them down to fetching new data
    currenciesToken = dataModel.$allCurrencies
      /// we want to proceed only if:
      /// - new currency was selected
      /// - user selected another currency as a base
      //.filter { _ in dataModel.base != nil }
      .filter { $0.contains { $0.isBase == true } } /// ensure baseCurrency is set, otherwise we don't care
      .scan([], { old, new -> [Currency] in
        let oldSelected = old.filter { $0.isSelected || $0.isBase }
        let newSelected = new.filter { $0.isSelected || $0.isBase }
        return Set(newSelected).isSubset(of: Set(oldSelected)) ? oldSelected : newSelected
      })
      .removeDuplicates()
      .filter { !$0.isEmpty } // don't proceed if empty
      .sink(receiveCompletion: { _ in },
        receiveValue: { currencies in
          let baseCode = currencies.first { $0.isBase == true }!.code
          self.fetchExchangeCurrency(for: baseCode, others: currencies.map { $0.code })
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
        receiveValue: {
          print($0)
          self.exchangeRates = $0
      })
  }
}
