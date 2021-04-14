//
//  MainViewRow.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainViewRow: View {
  
  @Binding var currency: Currency
  var rate: Double
  
  var body: some View {
    HStack(alignment: .center) {
      FlagView(code: currency.code)
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
      Text(formatValue(for: rate))
        .font(.system(.headline, design: .monospaced))
    }
  }
  
  private func formatValue(for value: Double) -> String {
    if value.isZero { return "--" }
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.minimumIntegerDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.roundingMode = .halfUp
    return formatter.string(for: value)!
  }
}

struct MainViewRow_Previews: PreviewProvider {
  static let czk = Currency(name: "Czech Republic Koruna", code: "CZK", symbol: "Kč")
    static var previews: some View {
      MainViewRow(currency: .constant(czk), rate: Double(1.0))
    }
}
