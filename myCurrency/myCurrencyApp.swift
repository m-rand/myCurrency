//
//  myCurrencyApp.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import SwiftUI

@main
struct myCurrencyApp: App {

  private var env = AppEnvironment.build()
  var body: some Scene {
    WindowGroup {
      MainView(viewModel: MainView.ViewModel(env: env), state: env.state)
        .environment(\.injected, env)
    }
  }

}
