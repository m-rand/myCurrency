//
//  myCurrencyApp.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import SwiftUI

@main
struct myCurrencyApp: App {
  @StateObject private var state = AppState()
  var body: some Scene {
    WindowGroup {
      MainView(state: state) {
        state.save()
      }
      .onAppear {
        state.load()
      }
    }
  }
}