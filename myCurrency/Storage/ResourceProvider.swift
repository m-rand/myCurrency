//
//  ResourceProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 21.04.2021.
//

import Foundation

protocol ResourceProvider {
  func load<T: Decodable>(_ filename: String) -> T
}

struct Resource: ResourceProvider {
  func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
      print("Couldn't find \(filename) in main bundle.")
      return [] as! T
    }
    
    do {
      data = try Data(contentsOf: file)
    } catch {
      print("Couldn't load \(filename) from main bundle:\n\(error)")
      return [] as! T
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      print("Couldn't parse \(filename) as \(T.self):\n\(error)")
      return [] as! T
    }
  }
}
