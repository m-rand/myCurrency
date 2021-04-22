//
//  CurrencyDocumentStorage.swift
//  myCurrency
//
//  Created by Marcel Baláš on 17.04.2021.
//

import Foundation
import Combine

struct CurrencyDocumentStorage: AsyncStorageProvider {
  
  private var fileName = "myCurrencies"
  private var fileExtension = "json"
  
  func fileURL() throws -> URL {
    try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
      .appendingPathComponent(fileName)
      .appendingPathExtension(fileExtension)
  }
  
  func load() -> Future<CurrencyStorageList, Error> {
    Future { promise in
      DispatchQueue.global(qos: .background).async {
        let path = try! self.fileURL().path
        if !FileManager.default.fileExists(atPath: path) {
          let item = CurrencyStorageList(base: nil, currencies: [])
          promise(.success(item))
        } else {
          do {
            let data = try Data(contentsOf: self.fileURL())
            let result = try JSONDecoder().decode(CurrencyStorageList.self, from: data)
            let item = CurrencyStorageList(base: result.base, currencies: result.currencies)
            promise(.success(item))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  }
  
  func save(value: CurrencyStorageList) -> Future<Void, Error> {
    Future { promise in
      DispatchQueue.global(qos: .background).async {
        let myList = CurrencyStorageList(base: value.base ?? "", currencies: value.currencies)
        do {
          let data = try JSONEncoder().encode(myList)
          try data.write(to: self.fileURL())
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
  } 
}
