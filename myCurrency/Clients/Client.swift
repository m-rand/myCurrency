//
//  Client.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine


enum TestFailureCondition: Error {
  case invalidServerResponse
}

struct Response<T> {
  let value: T
  let response: URLResponse
}

protocol APIClient {
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
  func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error>
  func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

extension APIClient {
  
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { result -> Response<T> in
        guard let httpResponse = result.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw TestFailureCondition.invalidServerResponse
        }
        let value = try self.decode(T.self, from: result.data)
        return Response(value: value, response: result.response)
      }
      .eraseToAnyPublisher()
  }
}
