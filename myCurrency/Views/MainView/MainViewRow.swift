//
//  MainViewRow.swift
//  myCurrency
//
//  Created by Marcel Baláš on 12.04.2021.
//

import SwiftUI

struct MainViewRow: View {
  
  @Binding var currency: Currency
  let formatter = NumberFormatter()
  
  var body: some View {
    HStack {
      Text(currency.code)
      Text(currency.name)
      Spacer()
      Text(formatValue(value: currency.value))
    }
    .background(currency.isBase ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground))
    .onTapGesture(perform: {
      currency.isBase = true
      print("tap")
    })
  }
  
  private func formatValue(value: Double) -> String {
    guard (value.isNaN) else {
      return "--"
    }
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.maximumFractionDigits = 2
    formatter.maximumIntegerDigits = 2
    return formatter.string(for: value) ?? "--"
  }
}

struct MainViewRow_Previews: PreviewProvider {
  static let czk = Currency(name: "Czech Republic Koruna", code: "CZK", symbol: "Kč")
    static var previews: some View {
      MainViewRow(currency: .constant(czk))
    }
}
