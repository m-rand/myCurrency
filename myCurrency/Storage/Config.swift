//
//  ResourceProvider.swift
//  myCurrency
//
//  Created by Marcel Baláš on 21.04.2021.
//

import Foundation


struct ConfigItem: Codable {
  var name: String
  var code: String
  var symbol: String
}

enum ConfigError: Error {
  case fileDoesNotExist
  case noDataInFile
  case dataCorrupted
}

struct ConfigProviding {
  let load: (_ filename: String) throws -> [ConfigItem]
}

extension ConfigProviding {
  
  // MARK: - release
  public static let release = Self(
    load: { filename in
      let data: Data      
      do {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
          throw ConfigError.fileDoesNotExist
        }
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode([ConfigItem].self, from: data)
      } catch DecodingError.dataCorrupted {
        throw ConfigError.dataCorrupted
      } catch {
        throw ConfigError.noDataInFile
      }
    }
  )
  
  // MARK: - failing
  #if DEBUG
  public static let failing = Self(
    load: { name in
      throw ConfigError.fileDoesNotExist
    }
  )
  #endif
}
