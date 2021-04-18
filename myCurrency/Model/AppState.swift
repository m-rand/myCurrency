//
//  DataModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine

class AppState: ObservableObject {
  
  private var storage: AsyncStorageProvider
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
  var error: Error? {
    willSet {
      hasError = newValue != nil
    }
  }
  var cancellables = Set<AnyCancellable>()
  
  init(storage: AsyncStorageProvider) {
    self.storage = storage
  }
}

extension AppState {
  
  func update(with currencies:[CurrencyStorageItem]) {
    allCurrencies.mapInPlace({ c in
      c.isSelected = currencies.contains(where: { $0.code == c.code })
    })
  }
  
  func load() {
    allCurrencies = load("currencies.json")
    storage.load()
      .print()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
          case .failure(let error):
            self.error = error
          case .finished: ()
        }
      }, receiveValue: { item in
        self.update(with: item.currencies)
        self.base = item.base
      })
      .store(in: &cancellables)
  }
  
  func save() {
    let list = CurrencyStorageList(
      base: base,
      currencies: allCurrencies.filter{$0.isSelected}.map{ CurrencyStorageItem(code: $0.code)}
    )
    storage.save(value: list)
      .print()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
          case .failure(let error):
            self.error = error
          case .finished: ()
        }
      }, receiveValue: { _ in })
      .store(in: &cancellables)
  }
}

extension AppState {
  
  func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
      print("Couldn't find \(filename) in main bundle.")
      return [] as! T
    }

    do {
      data = try Data(contentsOf: file)
    } catch {
      print("Couldn't load \(filename) from main bundle:\n\(error)")
      return [] as! T
    }

    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      print("Couldn't parse \(filename) as \(T.self):\n\(error)")
      return [] as! T
    }
  }
}

extension Array {
  mutating func mapInPlace(_ transform: (inout Element) -> ()) {
    for i in indices {
      transform(&self[i])
    }
  }
}
