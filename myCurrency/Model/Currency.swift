//
//  Currency.swift
//  myCurrency
//
//  Created by Marcel Baláš on 09.04.2021.
//

import Foundation


struct Currency: Identifiable, Codable, Equatable {

  let id = UUID()
  var name: String
  var code: String
  var symbol: String
  var value: Double = Double.zero
  var isSelected: Bool = false
  //var isBase: Bool = false
  
  
  enum CodingKeys: String, CodingKey {
    case code, name, symbol
  }

}

