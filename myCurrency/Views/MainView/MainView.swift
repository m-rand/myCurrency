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
  @ObservedObject var exchangeProvider: ExchangeCurrencyProvider
  @State private var showingSelection = false
  @State private var showingAlert: Bool = false
  @State private var alertTitle: String = ""
  @State private var alertMessage: String = ""
  var myCurrencies: [Currency] {
    state.allCurrencies.filter { $0.isSelected }.sorted { $0.code == state.base && $1.code != state.base }
  }
  let saveAction: () -> Void
  
  var body: some View {
    NavigationView {
      ZStack {
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
        .animation(.spring())
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("My Currencies")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing:
          Button(action: {
            showingSelection = true
          }) {
            Image(systemName: "plus.circle")
              .font(.title)
          })
        .alert(isPresented: $state.hasError, content: {
          Alert(
            title: Text("ERROR"),
            message: Text(state.error?.localizedDescription ?? "Unknown error."),
            dismissButton: .default(Text("OK"))
          )
        })
        .fullScreenCover(isPresented: $showingSelection) {
          NavigationView {
            SelectionView(state: state, showing: $showingSelection)
          }
        }
        
        if (myCurrencies.isEmpty) {
          EmptyView()
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
  static var state = AppState(storage: CurrencyDocumentStorage())
  static var previews: some View {
    MainView(state: state, exchangeProvider: ExchangeCurrencyProvider(), saveAction: {})
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
