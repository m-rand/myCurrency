//
//  FlagView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import SwiftUI

struct FlagView: View {
  @StateObject private var model = FlagsViewModel()
  let code: String

  var body: some View {
    Group {
      if let data = model.imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFit()
      } else if model.isLoading {
        ProgressView()
      } else {
        Image(systemName: "") // intentionally empty
      }
    }
    .onAppear {
      model.loadImage(for: code)
    }
  }
}

struct FlagView_Previews: PreviewProvider {
  static var previews: some View {
    FlagView(code: "CZK")
  }
}
