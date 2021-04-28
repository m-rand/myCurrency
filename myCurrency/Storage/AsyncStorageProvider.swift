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

struct AsyncStorageProviding {
  var load: () -> Future<CurrencyStorageList, Error>
  var save: (_ value: CurrencyStorageList) -> Future<Void, Error>
  init(
    load: @escaping () -> Future<CurrencyStorageList, Error>,
    save: @escaping (_ value: CurrencyStorageList) -> Future<Void, Error>
  ) {
    self.load = load
    self.save = save
  }
}

// MARK: release implementation
extension AsyncStorageProviding {

  private static let fileName = "myCurrencies"
  private static let fileExtension = "json"
  
  static func fileURL() throws -> URL {
    try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
    .appendingPathComponent(fileName)
    .appendingPathExtension(fileExtension)
  }
  
  public static let release = Self(
    load: {
      Future { promise in
        DispatchQueue.global(qos: .background).async {
          let path = try! Self.fileURL().path
          if !FileManager.default.fileExists(atPath: path) {
            let item = CurrencyStorageList(base: nil, currencies: [])
            promise(.success(item))
          } else {
            do {
              let data = try Data(contentsOf: Self.fileURL())
              let result = try JSONDecoder().decode(CurrencyStorageList.self, from: data)
              let item = CurrencyStorageList(base: result.base, currencies: result.currencies)
              promise(.success(item))
            } catch {
              promise(.failure(error))
            }
          }
        }
      }
    },
    save: { value in
      Future { promise in
        DispatchQueue.global(qos: .background).async {
          let myList = CurrencyStorageList(base: value.base ?? "", currencies: value.currencies)
          do {
            let data = try JSONEncoder().encode(myList)
            try data.write(to: Self.fileURL())
            promise(.success(()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  )
}

// MARK: simulate failure & success behavior
#if DEBUG
extension AsyncStorageProviding {
  
  enum TestFailureError: Error {
    case testFailure
  }
  
  public static let failing = Self(
    load: { Future { promise in
      promise(.failure(TestFailureError.testFailure))
    }},
    save: { _ in
      Future { promise in
        promise(.failure(TestFailureError.testFailure))
      }
    }
  )
  
  public static let success = Self(
    load: { Future { promise in
      promise(.success(
         CurrencyStorageList(
           base: "EUR",
           currencies: [
             CurrencyStorageItem(code: "CZK"),
             CurrencyStorageItem(code: "EUR"),
             CurrencyStorageItem(code: "USD")
           ]
         )
      ))
    }},
    save: { _ in
      Future { promise in
        promise(Result.success(()))
      }
    }
  )
  
}
#endif
