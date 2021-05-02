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
  private let client: APIClient
  private let request: FlagImageRequestProviding
  private let decoder: DecoderProviding<Data>
  private var cancellables = Set<AnyCancellable>()
  
  init(
    client: APIClient,
    request: FlagImageRequestProviding,
    decoder: DecoderProviding<Data>,
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
          .sink { [weak self] img in
            self?.cache.set(img, code)
            promise(.success(img))
          }
          .store(in: &self.cancellables)
      }
    }
  }
}
