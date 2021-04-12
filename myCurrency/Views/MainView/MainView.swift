//
//  MainView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainView: View {
  
  @EnvironmentObject var model: DataModel
  @State private var exchangeProvider: ExchangeCurrencyProvider?
  @State private var showingSelection = false
  var myCurrencies: [Currency] {
    model.allCurrencies.filter { $0.isSelected }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(myCurrencies, id: \.self) { currency in
          MainViewRow(currency: binding(for: currency))
        }
      }
      .navigationTitle("My Currencies")
      .navigationBarTitleDisplayMode(.large)
      .navigationBarItems(trailing: Button(action: {
        showingSelection = true
      }) {
        Image(systemName: "plus")
          .font(.largeTitle)
      })
    }
    .fullScreenCover(isPresented: $showingSelection) {
      NavigationView {
        SelectionView()
          .navigationBarItems(leading: Button("Dismiss") {
            showingSelection = false
          }, trailing: Button("Done") {
            showingSelection = false
          })
      }
    }
    .onAppear(perform: {
      if (exchangeProvider == nil) {
        exchangeProvider = ExchangeCurrencyProvider(dataModel: model)
      }
    })
  }
  
  private func binding(for currency: Currency) -> Binding<Currency> {
    guard let idx = model.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $model.allCurrencies[idx]
  }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
