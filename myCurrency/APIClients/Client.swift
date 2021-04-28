//
//  Client.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine


enum ServerError: Error {
  case invalidServerResponse
}

struct APIClient {
  var execute: (_ request: URLRequest) -> AnyPublisher<Data, Error>
  init(
    execute: @escaping (_ request: URLRequest) -> AnyPublisher<Data, Error>
  ) {
    self.execute = execute
  }
}

extension APIClient {
  static func execute(_ request: URLRequest) -> AnyPublisher<Data, Error> {
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw ServerError.invalidServerResponse
        }
        return data
      }
      .eraseToAnyPublisher()
  }
  
  // MARK: release
  public static let release = Self(
    execute: { request in
      return execute(request)
    }
  )
  
  // MARK: failing
  public static let failing = Self(
    execute: { request in
      return
        Future { promise in
          promise(.failure(ServerError.invalidServerResponse))
        }
        .eraseToAnyPublisher()
    }
  )
}

