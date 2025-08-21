//
//  AppConstants.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation

struct AppConstants {
    
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://api.coingecko.com/api/v3"
        static let timeoutInterval: TimeInterval = 30
        static let cacheExpirationTime: TimeInterval = 300 // 5 minutos
    }
    
    // MARK: - UI Configuration
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 2
        static let shadowOpacity: Float = 0.1
        static let searchDebounceTime: TimeInterval = 0.3
        static let cryptoIconSize: CGFloat = 40
    }
    
    // MARK: - Cache Configuration
    struct Cache {
        static let maxCachedItems = 100
        static let cryptoCurrenciesKey = "cached_crypto_currencies"
        static let cacheExpirationKey = "crypto_cache_expiration"
    }
    
    // MARK: - Default Values
    struct Defaults {
        static let pageSize = 100
        static let currency = "usd"
        static let orderBy = "market_cap_desc"
    }
}
