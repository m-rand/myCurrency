//
//  MainViewRow.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainViewRow: View {
  
  var currency: Currency
  var rate: Double
  
  var body: some View {
    HStack(alignment: .center) {
      FlagView(
        code: currency.code
      )
        .frame(width: 48, height: 32)
      VStack(alignment: .leading) {
        Text(currency.name)
          .font(.headline)
          .truncationMode(.tail)
          .lineLimit(1)
          .foregroundColor(.primary)
        
        HStack(alignment: .center) {
          Text(currency.code)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      .padding(.leading)
      Spacer()
      HStack(spacing: 5) {
        Text(currency.symbol)
        Text(rate.currencyFormat)
          .font(.system(.headline, design: .monospaced))
      }
    }
  }
}

struct MainViewRow_Previews: PreviewProvider {
  static let czk = Currency(name: "Czech Republic Koruna", code: "CZK", symbol: "Kč")
  static var previews: some View {
    MainViewRow(currency: czk, rate: Double(1.0))
  }
}
