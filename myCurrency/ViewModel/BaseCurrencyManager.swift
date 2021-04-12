//
//  BaseCurrencyManager.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import Foundation
import Combine


class BaseCurrencyManager {
  private var dataModel: DataModel
  private var observer: AnyCancellable?
  private var lastBaseCurrency: Currency?
  
  init(dataModel: DataModel) {
    self.dataModel = dataModel
    
    observer = dataModel.$myCurrencies
      .sink(receiveCompletion: { _ in },
        receiveValue: { currencies in
          let base = currencies.filter { $0.isBase }.first
          if (base != self.lastBaseCurrency) {
            
          }
      })
  }
}
