//
//  StorageProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 17.04.2021.
//

import Foundation
import Combine

enum StorageError: Error {
  // MARK: TODO
}

struct CurrencyStorageItem : Codable {
  let code: String
}
struct CurrencyStorageList : Codable {
  var base: String?
  var currencies: [CurrencyStorageItem]
}

protocol AsyncStorageProvider {
  func load() -> Future<CurrencyStorageList, Error>
  func save(value: CurrencyStorageList) -> Future<Void, Error>
}
