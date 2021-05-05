//
//  Array+Extensions.swift
//  myCurrency
//
//  Created by Marcel Baláš on 04.05.2021.
//

import Foundation

extension Array {
  mutating func mapInPlace(_ transform: (inout Element) -> ()) {
    for i in indices {
      transform(&self[i])
    }
  }
}
