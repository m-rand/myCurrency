//
//  FlagImageCache.swift
//  myCurrency
//
//  Created by Marcel Baláš on 28.04.2021.
//

import Foundation

struct FlagImageCache {
  var get: (_ key: String) -> Data?
  var set: (_ object: Data, _ key: String) -> Void
}

extension FlagImageCache {
  
  // MARK: release
  public static var release: Self {
    let cache = NSCache<NSString, NSData>()
    return Self(
      get: { key in
        cache.object(forKey: key as NSString) as Data?
      },
      set: { object, key in
        cache.setObject(object as NSData, forKey: key as NSString)
      }
    )
  }
  
  // MARK: failing
  #if DEBUG
  public static let failing = Self(
    get: { _ in return nil },
    set: { object, key in return }
  )
  #endif
}
