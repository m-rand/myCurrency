//
//  FlagsViewModel.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import Foundation
import Combine

class FlagsViewModel: ObservableObject {
  
  static let urlString = "https://raw.githubusercontent.com/transferwise/currency-flags/master/src/flags/"
  @Published var imageData: Data?
  @Published var isLoading = false
  
  private static let cache = NSCache<NSURL, NSData>() // static for all-app cache
  private var cancellables = Set<AnyCancellable>()
  
  func loadImage(for code: String) {
    
    isLoading = true
    let urlString = FlagsViewModel.urlString + code.lowercased() + ".png"
    
    guard let url = URL(string: urlString) else {
      isLoading = false
      return
    }
    
    if let data = Self.cache.object(forKey: url as NSURL) {
      imageData = data as Data
      isLoading = false
      return
    }
    
    let request = URLRequest(url: url, timeoutInterval: 5)
    URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        #if DEBUG
        print("received flag for url: ", url)
        #endif
        if let data = $0 {
          Self.cache.setObject(data as NSData, forKey: url as NSURL)
          self?.imageData = data
        }
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
}
