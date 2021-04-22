//
//  FlagView.swift
//  myCurrency
//
//  Created by Marcel Baláš on 10.04.2021.
//

import SwiftUI
import Combine

struct FlagView: View {
  
  @StateObject private var model = ViewModel()
  let flagImageProvider: FlagImageProvider
  let code: String

  var body: some View {
    Group {
      if let uiImage = model.image {
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
      model.flagImageProvider = self.flagImageProvider
      model.loadImage(for: code)
    }
  }
}
/*
struct FlagView_Previews: PreviewProvider {
  static var previews: some View {
    FlagView(code: "CZK")
  }
}
*/
extension FlagView {
  class ViewModel: ObservableObject {
    var flagImageProvider: FlagImageProvider?
    @Published var image: UIImage?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    func loadImage(for code: String) {
      flagImageProvider?.loadImage(for: code)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { item in
          self.image = UIImage(data: item)
        })
        .store(in: &cancellables)
    }
  }
}
