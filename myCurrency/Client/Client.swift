//
//  Client.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation
import Combine

class Client {

  struct Response<T> {
    let value: T
    let response: URLResponse
  }
  
  func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { result -> Response<T> in
          let value = try JSONDecoder().decode(T.self, from: result.data)
          return Response(value: value, response: result.response)
      }
      .eraseToAnyPublisher()
  }
}
