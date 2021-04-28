//
//  FlagImageRequest.swift
//  myCurrency
//
//  Created by Marcel Baláš on 19.04.2021.
//

import Foundation


struct FlagImageRequestProviding {
  var buildRequest: (_ code: String) -> URLRequest
}

extension FlagImageRequestProviding {
  
  // MARK: release implementation
  public static var release = Self(
    buildRequest: { code in
      let urlString = "https://raw.githubusercontent.com/transferwise/currency-flags/master/src/flags/"
      let url = URL(string: urlString + code.lowercased() + ".png")!
      return URLRequest(url: url)
    }
  )
  
  // MARK: failing
  #if DEBUG
  public static let failing = Self(
    buildRequest: { code in
      let url = URL(string: "\\\\")!
      return URLRequest(url: url)
    }
  )
  #endif
}
