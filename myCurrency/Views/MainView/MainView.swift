//
//  MainView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainView: View {
  
  @Environment(\.scenePhase) private var scenePhase
  @ObservedObject var state = Env.state // make it observable so as SwiftUI view can do diffing
  @State private var showingSelection = false
  @State private var showingAlert: Bool = false
  @State private var alertTitle: String = ""
  @State private var alertMessage: String = ""
  @State private var currenciesProvider = Env.currenciesProvider
  
  var myCurrencies: [Currency] {
    state.allCurrencies
      .filter { $0.isSelected }
      .sorted { $0.code == state.base && $1.code != state.base }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(myCurrencies) { currency in
            MainViewRow(
              currency: currency,
              rate: (state.base ?? "").isEmpty
                ? Double.zero
                : state.exchangeRates.rates[currency.code] ?? Double.zero
            )
              .onTapGesture(perform: {
                withAnimation(.linear) { state.base = currency.code }
              })
              .listRowBackground(state.base == currency.code
                ? Color("accentBackground")
                : Color(UIColor.secondarySystemGroupedBackground))
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
            SelectionView(showing: $showingSelection)
          }
        }
        
        // MARK: Empty view
        if (myCurrencies.isEmpty) {
          EmptyView()
        }
      }
    }
    .onAppear( perform: {
      currenciesProvider.load()
    })
    .onChange(of: scenePhase, perform: { phase in
      if phase == .inactive { currenciesProvider.save() }
    })
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .onAppear {
        Env.currenciesProvider.load()
        Env.state.allCurrencies = Env.state.allCurrencies.map {
          var currency = $0
          if $0.code == "EUR" || $0.code == "USD" || $0.code == "CZK" {
            currency.isSelected = true
          }
          return currency
        }
        Env.state.base = "EUR"
      }
  }
}

