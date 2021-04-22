//
//  MainView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainView: View {
  
  @Environment(\.scenePhase) private var scenePhase
  @ObservedObject private(set) var viewModel: ViewModel
  @ObservedObject var state: AppState // SwiftUI hack for refreshing view
  @State private var showingSelection = false
  @State private var showingAlert: Bool = false
  @State private var alertTitle: String = ""
  @State private var alertMessage: String = ""
  
  var myCurrencies: [Currency] {
    viewModel.env.state.allCurrencies.filter {
      $0.isSelected
    }.sorted {
      $0.code == viewModel.env.state.base &&
      $1.code != viewModel.env.state.base
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(myCurrencies) { currency in
            MainViewRow(
              env: viewModel.env,
              currency: binding(for: currency),
              rate: (viewModel.env.state.base ?? "").isEmpty ? Double.zero : viewModel.env.state.exchangeRates.rates[currency.code] ?? Double.zero)
              .onTapGesture(perform: {
                withAnimation(.linear) {
                  viewModel.env.state.base = currency.code
                }
              })
              .listRowBackground(viewModel.env.state.base == currency.code ? Color("accentBackground") : Color(UIColor.secondarySystemGroupedBackground))
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
        .alert(isPresented: $viewModel.env.state.hasError, content: {
          Alert(
            title: Text("ERROR"),
            message: Text(viewModel.env.state.error?.localizedDescription ?? "Unknown error."),
            dismissButton: .default(Text("OK"))
          )
        })
        .fullScreenCover(isPresented: $showingSelection) {
          NavigationView {
            SelectionView(viewModel: SelectionView.ViewModel(env: viewModel.env), showing: $showingSelection)
          }
        }
        
        if (myCurrencies.isEmpty) {
          EmptyView()
        }
      }
    }
    .onAppear( perform: {
      viewModel.env.model.currenciesProvider.load()
    })
    .onChange(of: scenePhase, perform: { phase in
      if phase == .inactive { viewModel.env.model.currenciesProvider.save() }
    })
  }
  
  private func binding(for currency: Currency) -> Binding<Currency> {
    guard let idx = viewModel.env.state.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $viewModel.env.state.allCurrencies[idx]
  }
}
/*
struct MainView_Previews: PreviewProvider {
  static var state = AppState()
  static var previews: some View {
    MainView(viewModel.env.state: state, exchangeProvider: ExchangeRateProvider(), saveAction: {})
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
*/

extension MainView {
  class ViewModel: ObservableObject {
    var env: AppEnvironment
    
    init(env: AppEnvironment) {
      self.env = env
    }
  }
}
