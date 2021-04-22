//
//  SelectionView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 11.04.2021.
//

import SwiftUI

struct SelectionView: View {
  
  @ObservedObject private(set) var viewModel: ViewModel
  @State var currencyToSearch: String = ""
  @State var showSelectedOnly: Bool = false
  @Binding var showing: Bool
  var filteredCurrencies: [Currency] {
    viewModel.env.state.allCurrencies.filter {
      (!showSelectedOnly || $0.isSelected) &&
      (currencyToSearch.isEmpty
        ? true : $0.name.lowercased().contains(currencyToSearch.lowercased()))
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
          SelectionRow(
            env: viewModel.env,
            currency: binding(for: currency)
          )
        }
      }
      .animation(.spring())
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
    guard let idx = viewModel.env.state.allCurrencies.firstIndex(of: currency) else {
      fatalError()
    }
    return $viewModel.env.state.allCurrencies[idx]
  }
}
/*
struct SelectionView_Previews: PreviewProvider {
  static var showing = true
  static var previews: some View {
    SelectionView(state: AppState(storage: CurrencyDocumentStorage()), showing: .constant(showing))
  }
}
*/

extension SelectionView {
  class ViewModel: ObservableObject {
    var env: AppEnvironment
    
    init(env: AppEnvironment) {
      self.env = env
    }
  }
}
