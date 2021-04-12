//
//  DataModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation

class DataModel: ObservableObject {
  
  private let currencyStorage = CurrencyStorage()
  @Published var allCurrencies: [Currency] = load("currencies.json")
  @Published var myCurrencies: [Currency]
  var baseCurrency: Currency? {
    myCurrencies.filter { $0.isBase }.first
  }
  @Published var base: String? // contatins code of currency selected as a base
  
  init() {
    self.myCurrencies = currencyStorage.fetchMyCurrencies()
  }
}


fileprivate func load<T: Decodable>(_ filename: String) -> T {
  let data: Data

  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
  else {
    fatalError("Couldn't find \(filename) in main bundle.")
  }

  do {
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
  }

  do {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}


