//
//  SelectionView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 11.04.2021.
//

import SwiftUI

struct SelectionView: View {
  
  @EnvironmentObject var dataModel: DataModel
  @State var currencyToSearch: String = ""
  var filteredCurrencies: [Currency] {
    dataModel.allCurrencies.filter { currencyToSearch.isEmpty ? true : $0.name.contains(currencyToSearch) }
  }
  @State var myCurrencies = [Currency]()
  
  var body: some View {
    SearchBar(text: $currencyToSearch, placeholder: "Currency name...")
    List {
      ForEach(filteredCurrencies, id: \.self) { currency in
        SelectionRow(currency: binding(for: currency))
      }
    }
    .listStyle(InsetListStyle())
    .navigationTitle("All currencies")
  }
  
  private func binding(for currency: Currency) -> Binding<Currency> {
    guard let idx = dataModel.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $dataModel.allCurrencies[idx]
  }
}

struct SelectionView_Previews: PreviewProvider {
  static var previews: some View {
    SelectionView()
  }
}

