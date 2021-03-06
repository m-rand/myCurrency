//
//  AppEnvironment.swift
//  myCurrency
//
//  Created by Marcel Baláš on 20.04.2021.
//

import Foundation
import SwiftUI



struct AppEnvironment {
  var state: AppState
  let flagImageProvider: FlagImageProvider
  let exchangeRateProvider: ExchangeRateProvider
  let currenciesProvider: CurrenciesProvider
}

extension AppEnvironment {
  
  // MARK: release
  public static var release: Self {
    let state = AppState()
    return Self(
      state: state,
      flagImageProvider: FlagImageProvider(client: .release, request: .release, decoder: .release, cache: .release),
      exchangeRateProvider: ExchangeRateProvider(client: .release, request: .release, decoder: .release, state: state),
      currenciesProvider: CurrenciesProvider(state: state, storage: .release, config: .release)
    )
  }
  
  // MARK: failing
  #if DEBUG
  public static var failing: Self {
    let state = AppState()
    return Self(
      state: state,
      flagImageProvider: FlagImageProvider(client: .failing, request: .failing, decoder: .failing, cache: .failing),
      exchangeRateProvider: ExchangeRateProvider(client: .failing, request: .failing, decoder: .failing, state: state),
      currenciesProvider: CurrenciesProvider(state: state, storage: .failing, config: .failing)
    )
  }
  #endif
}

// Singleton!!! Well, it does not have to be such bad. :)
// https://www.pointfree.co/blog/posts/21-how-to-control-the-world
var Env = AppEnvironment.release
