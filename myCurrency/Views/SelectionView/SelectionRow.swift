//
//  SelectionRow.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct SelectionRow: View {
  
  var env: AppEnvironment
  @Binding var currency: Currency
  
  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      FlagView(
        flagImageProvider: env.model.flagImageProvider,
        code: currency.code
      )
        .frame(width: 48, height: 32)
      VStack(alignment: .leading, spacing: 4) {
        Text(currency.name)
          .font(.headline)
          .truncationMode(.tail)
          .lineLimit(1)
          .foregroundColor(.primary)
          
        HStack(alignment: .center, spacing: 8) {
          Text(currency.code)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      .padding(.leading)
      Spacer()
      Toggle(" ", isOn: $currency.isSelected)
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
  }
  

}
/*
struct SelectionRow_Previews: PreviewProvider {
  static let czk = Currency(name: "Czech Republic Koruna", code: "CZK", symbol: "Kč")
  static var previews: some View {
    SelectionRow(state: AppState(storage: CurrencyDocumentStorage()), currency: .constant(czk))
  }
}
*/
