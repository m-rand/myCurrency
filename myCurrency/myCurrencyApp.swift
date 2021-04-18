//
//  myCurrencyApp.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import SwiftUI

@main
struct myCurrencyApp: App {
  @StateObject private var state = AppState(storage: CurrencyDocumentStorage())
  @StateObject private var rates = ExchangeCurrencyProvider()
  
  var body: some Scene {
    WindowGroup {
      MainView(state: state, exchangeProvider: rates) {
        state.save()
      }
      .onAppear(perform: {
        state.load()
        rates.setup(state: state)
      })
    }
  }
}
