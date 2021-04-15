//
//  DataModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation

class AppState: ObservableObject {
  
  private let currencyStorage = CurrencyStorage()
  @Published var allCurrencies = [Currency]() {
    willSet {
      let filtered = newValue.filter{ $0.isSelected }
      if filtered.isEmpty || !filtered.contains(where: { $0.code == base }) {
        base = ""
      }
    }
  }
  @Published var base: String? // contains code of currency selected as a base

}

extension AppState {
  func update(from currencies:[Currency]) -> [Currency]{
    return allCurrencies.map {
      var newCurrency = $0
      newCurrency.isSelected = currencies.contains { $0.code == newCurrency.code }
      return newCurrency
    }
  }
  
  func load() {
    allCurrencies = load("currencies.json");
    let myCurrencies = currencyStorage.load()
    base = myCurrencies.0
    allCurrencies = update(from: myCurrencies.1)
  }
  
  func save() {
    currencyStorage.save(base: base, currencies: allCurrencies.filter { $0.isSelected })
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

