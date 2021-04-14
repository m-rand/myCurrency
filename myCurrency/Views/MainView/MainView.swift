//
//  MainView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainView: View {
  
  @Environment(\.scenePhase) private var scenePhase
  @ObservedObject var state: AppState
  @StateObject private var exchangeProvider = ExchangeCurrencyProvider()
  @State private var showingSelection = false
  var myCurrencies: [Currency] {
    state.allCurrencies.filter { $0.isSelected }.sorted { $0.code == state.base && $1.code != state.base }
  }
  let saveAction: () -> Void
  
  var body: some View {
    NavigationView {
      List {
        ForEach(myCurrencies) { currency in
          MainViewRow(
            currency: binding(for: currency),
            rate: (state.base ?? "").isEmpty ? Double.zero : exchangeProvider.exchangeRates.rates[currency.code] ?? Double.zero)
            .onTapGesture(perform: {
              withAnimation(.linear) {
                state.base = currency.code
              }
            })
            .listRowBackground(state.base == currency.code ? Color("accentBackground") : Color(UIColor.secondarySystemGroupedBackground))
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("My Currencies")
      .navigationBarTitleDisplayMode(.large)
      .navigationBarItems(trailing: Button(action: {
        showingSelection = true
      }) {
        Image(systemName: "plus.circle")
          .font(.title)
      })
      .fullScreenCover(isPresented: $showingSelection) {
        NavigationView {
          SelectionView(state: state, showing: $showingSelection)
        }
      }
    }
    .onAppear(perform: {
      exchangeProvider.setup(state: state)
    })
    .onChange(of: scenePhase, perform: { phase in
      if phase == .inactive { saveAction() }
    })
  }
  
  private func binding(for currency: Currency) -> Binding<Currency> {
    guard let idx = state.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $state.allCurrencies[idx]
  }
}

struct MainView_Previews: PreviewProvider {
  static var state = AppState()
  static var previews: some View {
    MainView(state: state, saveAction: {})
      .onAppear {
        state.load()
        state.allCurrencies = state.allCurrencies.map {
          var currency = $0
          if $0.code == "EUR" || $0.code == "USD" || $0.code == "CZK" {
            currency.isSelected = true
          }
          return currency
        }
        state.base = "EUR"
      }
  }
}
