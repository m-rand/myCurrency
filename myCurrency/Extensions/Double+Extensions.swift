//
//  Double+Extensions.swift
//  myCurrency
//
//  Created by Marcel Baláš on 04.05.2021.
//

import Foundation

extension Double {
  var currencyFormat: String {
    let formatter = NumberFormatter.CurrencyFormatter
    return formatter.string(for: self)!
  }
}
