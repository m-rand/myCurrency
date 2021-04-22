//
//  AppEnvironment.swift
//  myCurrency
//
//  Created by Marcel Baláš on 20.04.2021.
//

import Foundation
import SwiftUI

struct StorageProviders {
  let storageProvider: AsyncStorageProvider
  let resourceProvider: ResourceProvider
}

struct ClientProviders {
  let flagImageClientProvider: FlagImageClient
  let exchangeRateClientProvider: ExchangeRateClient
}

struct RequestProviders {
  let flagImageRequestProvider: FlagImageRequestProvider
  let exchangeRateRequestProvider: ExchangeRateRequestProvider
}

struct ModelProvider {
  let flagImageProvider: FlagImageProvider
  let exchangeRateProvider: ExchangeRateProvider
  let currenciesProvider: CurrenciesProvider
}

struct AppEnvironment: EnvironmentKey {
  
  let storage: StorageProviders
  let clients: ClientProviders
  let requests: RequestProviders
  let model: ModelProvider
  var state: AppState
  
  static let defaultValue = AppEnvironment.build()
}

extension AppEnvironment {
  static func build() -> AppEnvironment {
    let state = AppState()
    let storageProviders = StorageProviders(
      storageProvider: CurrencyDocumentStorage(),
      resourceProvider: Resource()
    )
    let clientProviders = ClientProviders(
      flagImageClientProvider: FlagImageClient(),
      exchangeRateClientProvider: ExchangeRateClient()
    )
    let requestProviders = RequestProviders(
      flagImageRequestProvider: FlagImageRequest(),
      exchangeRateRequestProvider: ExchangeRateRequest()
    )
    let modelProvider = ModelProvider(
      flagImageProvider: FlagImageProvider(
        client: clientProviders.flagImageClientProvider,
        requestProvider: requestProviders.flagImageRequestProvider)
      , exchangeRateProvider: ExchangeRateProvider(
        client: clientProviders.exchangeRateClientProvider,
        requestProvider: requestProviders.exchangeRateRequestProvider,
        state: state
      ), currenciesProvider: CurrenciesProvider(
        state: state,
        storage: storageProviders.storageProvider,
        resource: storageProviders.resourceProvider
      )
    )
    
    return AppEnvironment(
      storage: storageProviders,
      clients: clientProviders,
      requests: requestProviders,
      model: modelProvider,
      state: state
    )
  }
}

extension EnvironmentValues {
  var injected: AppEnvironment {
    get { self[AppEnvironment.self] }
    set { self[AppEnvironment.self] = newValue }
  }
}

extension View {
  func injected(_ injected: AppEnvironment) -> some View {
    environment(\.injected, injected)
  }
}
