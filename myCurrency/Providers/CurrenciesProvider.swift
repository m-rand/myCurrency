//
//  CurrenciesProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 21.04.2021.
//

import Foundation
import Combine

final class CurrenciesProvider {
  private var state: AppState
  private var storage: AsyncStorageProviding
  private var config: ConfigProviding
  var cancellables = Set<AnyCancellable>()
  
  init(
    state: AppState,
    storage: AsyncStorageProviding,
    config: ConfigProviding
  ) {
    self.state = state
    self.storage = storage
    self.config = config
  }
}

extension CurrenciesProvider {
  
  private func update(with currencies:[CurrencyStorageItem]) {
    state.allCurrencies.mapInPlace({ c in
      c.isSelected = currencies.contains(where: { $0.code == c.code })
    })
  }
  
  private func loadConfig() throws -> [Currency] {
    let input = try config.load("currencies.json")
    return input.map { Currency(name: $0.name, code: $0.code, symbol: $0.symbol) }
  }
  
  func load() {
    do {
      state.allCurrencies = try loadConfig()
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
    } catch {
      state.error = error
    }
  }
  
  func save() {
    let list = CurrencyStorageList(
      base: state.base,
      currencies: state.allCurrencies
        .filter { $0.isSelected }
        .map { CurrencyStorageItem(code: $0.code) }
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
