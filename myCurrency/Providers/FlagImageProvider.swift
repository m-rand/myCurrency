//
//  FlagsViewModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import Foundation
import Combine

final class FlagImageProvider {
   
  private var cache: FlagImageCache
  private var client: APIClient
  private var request: FlagImageRequestProviding
  private var decoder: FlagImageDecoder
  private var cancellables = Set<AnyCancellable>()
  
  init(
    client: APIClient,
    request: FlagImageRequestProviding,
    decoder: FlagImageDecoder,
    cache: FlagImageCache
  ) {
    self.client = client
    self.request = request
    self.decoder = decoder
    self.cache = cache
  }
  
  func loadImage(for code: String) -> Future<Data, Never> {
    Future { promise in
      if let data = self.cache.get(code) {
        promise(.success(data as Data))
      } else {
        let request = self.request.buildRequest(code)
        self.client.execute(request)
          .decode(type: Data.self, decoder: self.decoder)
          .catch { err in Just(Data()) }
          .sink {
            self.cache.set($0, code)
            promise(.success($0))
          }
          .store(in: &self.cancellables)
      }
    }
  }
}
