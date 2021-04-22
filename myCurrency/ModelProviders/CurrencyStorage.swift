//
//  CurrencyStorage.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import Foundation

class CurrencyStorage {
  private static var documentsFolder: URL {
    do {
      return try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
    } catch {
      fatalError("Can't find documents directory.")
    }
  }
  private static var fileURL: URL {
    return documentsFolder
      .appendingPathComponent("myCurrencies")
      .appendingPathExtension("json")
  }
}

extension CurrencyStorage {
  
  func fetchMyCurrencies() -> [Currency] {
    guard let data = try? Data(contentsOf: Self.fileURL) else { return [] }
    let currencies = try? JSONDecoder().decode([Currency].self, from: data)
    return currencies ?? []
  }
  
  func save(_ currencies: [Currency]) {
    guard let data = try? JSONEncoder().encode(currencies) else { return }
    try? data.write(to: Self.fileURL)
  }
  
}
