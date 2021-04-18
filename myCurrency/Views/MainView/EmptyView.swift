//
//  EmptyView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 16.04.2021.
//

import SwiftUI

struct EmptyView: View {
  var body: some View {
    VStack {
      Text("You have no currencies to show.")
    }
    .font(.title3)
    .foregroundColor(.accentColor)
  }
}

struct EmptyView_Previews: PreviewProvider {
  static var previews: some View {
    EmptyView()
  }
}
