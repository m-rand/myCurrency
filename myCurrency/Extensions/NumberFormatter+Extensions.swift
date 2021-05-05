//
//  DataFormatter+Extensions.swift
//  myCurrency
//
//  Created by Marcel Baláš on 04.05.2021.
//

import Foundation

extension NumberFormatter {
  static let CurrencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.minimumIntegerDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.roundingMode = .halfUp
    return formatter
  }()
}
