//
//  FlagImageRequest.swift
//  myCurrency
//
//  Created by Marcel Baláš on 19.04.2021.
//

import Foundation

protocol FlagImageRequestProvider {
  func buildRequest(for code: String) -> URLRequest
}

struct FlagImageRequest: FlagImageRequestProvider {
  func buildRequest(for code: String) -> URLRequest {
    let urlString = "https://raw.githubusercontent.com/transferwise/currency-flags/master/src/flags/"
    let url = URL(string: urlString + code.lowercased() + ".png")!
    return URLRequest(url: url)
  }
}
