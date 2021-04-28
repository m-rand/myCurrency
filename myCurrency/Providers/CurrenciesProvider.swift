//
//  CurrenciesProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 21.04.2021.
//

import Foundation
import Combine

class CurrenciesProvider {
  private var state: AppState
  private var storage: AsyncStorageProviding
  private var resource: ResourceProvider
  var cancellables = Set<AnyCancellable>()
  
  init(
    state: AppState,
    storage: AsyncStorageProviding,
    resource: ResourceProvider
  ) {
    self.state = state
    self.storage = storage
    self.resource = resource
  }
}

extension CurrenciesProvider {
  
  func update(with currencies:[CurrencyStorageItem]) {
    state.allCurrencies.mapInPlace({ c in
      c.isSelected = currencies.contains(where: { $0.code == c.code })
    })
  }
  
  func load() {
    state.allCurrencies = resource.load("currencies.json")
    storage.load()
      .print()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.state.error = error
        case .finished: ()
        }
      }, receiveValue: { item in
        self.update(with: item.currencies)
        self.state.base = item.base
      })
      .store(in: &cancellables)
  }
  
  func save() {
    let list = CurrencyStorageList(
      base: state.base,
      currencies: state.allCurrencies.filter{$0.isSelected}.map{CurrencyStorageItem(code: $0.code)}
    )
    storage.save(list)
      .print()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.state.error = error
        case .finished: ()
        }
      }, receiveValue: { _ in })
      .store(in: &cancellables)
  }
}

extension Array {
  mutating func mapInPlace(_ transform: (inout Element) -> ()) {
    for i in indices {
      transform(&self[i])
    }
  }
}
