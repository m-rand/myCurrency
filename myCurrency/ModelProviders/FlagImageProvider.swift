//
//  FlagsViewModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import Foundation
import Combine


class FlagImageProvider {
   
  private static let cache = NSCache<NSString, NSData>()
  private var client: APIClient
  private var requestProvider: FlagImageRequestProvider
  private var cancellables = Set<AnyCancellable>()
  
  init(
    client: APIClient,
    requestProvider: FlagImageRequestProvider
  ) {
    self.client = client
    self.requestProvider = requestProvider
  }
  
  func loadImage(for code: String) -> Future<Data, Never> {
    Future { promise in
      if let data = Self.cache.object(forKey: code as NSString) {
        promise(.success(data as Data))
      } else {
        let request = self.requestProvider.buildRequest(for: code)
        self.client.execute(request)
          .replaceError(with: Data())
          .print()
          .sink {
            Self.cache.setObject($0 as NSData, forKey: code as NSString)
            promise(.success($0))
          }
          .store(in: &self.cancellables)
      }
    }
  }
}
