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
  
  struct MyCurrencyList: Codable {
    let base: String
    let currencies: [Currency]
  }
  
  func load() -> (String?, [Currency]) {
    guard let data = try? Data(contentsOf: Self.fileURL) else {
      #if DEBUG
      print("reading from file failed")
      #endif
      return (nil, [])
    }
    guard let currencies = try? JSONDecoder().decode(MyCurrencyList.self, from: data) else {
      #if DEBUG
      print("decoding failed")
      #endif
      return (nil, [])
    }
    #if DEBUG
    print("loaded: base: ", currencies.base, " currencies: ", currencies.currencies)
    #endif
    return (currencies.base, currencies.currencies)
  }
  
  func save(base: String?, currencies: [Currency]) {
    #if DEBUG
    print("save: base: ", base ?? "", " currencies: ", currencies)
    #endif
    let myList: MyCurrencyList = MyCurrencyList(base: base ?? "", currencies: currencies)
    guard let data = try? JSONEncoder().encode(myList) else {
      #if DEBUG
      print("encoding failed")
      #endif
      return
    }
    try? data.write(to: Self.fileURL)
  }
}
