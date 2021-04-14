//
//  SelectionView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 11.04.2021.
//

import SwiftUI

struct SelectionView: View {
  
  @ObservedObject var state: AppState
  @State var currencyToSearch: String = ""
  @State var showSelectedOnly: Bool = false
  @Binding var showing: Bool
  var filteredCurrencies: [Currency] {
    state.allCurrencies.filter {
      (!showSelectedOnly || $0.isSelected) &&
      currencyToSearch.isEmpty
        ? true : $0.name.lowercased().contains(currencyToSearch.lowercased())
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .center, spacing: 0) {
        SearchBar(text: $currencyToSearch, placeholder: "Currency name...")
          .padding(.vertical)
      }
      List {
        ForEach(filteredCurrencies) { currency in
          SelectionRow(state: state, currency: binding(for: currency))
        }
      }
    }
    .listStyle(InsetListStyle())
    .navigationBarTitle("All currencies")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        HStack {
          Button {
            showing = false
          } label: {
            Text("Done")
              .font(.title3)
              .fontWeight(.semibold)
        }
          Text("")
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack { /// workaround for changing font of the image
          Button(action: {
            showSelectedOnly.toggle()
          }, label: {
            Image(systemName: showSelectedOnly ? "line.horizontal.3.circle.fill" : "line.horizontal.3.circle")
              .font(.title)
          })
          Text("")
        }
      }
    }
  }
  
  private func binding(for currency: Currency) -> Binding<Currency> {
    guard let idx = state.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $state.allCurrencies[idx]
  }
}

struct SelectionView_Previews: PreviewProvider {
  static var showing = true
  static var previews: some View {
    SelectionView(state: AppState(), showing: .constant(showing))
  }
}

