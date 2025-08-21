//
//  CryptoCurrencyRemoteDataSource.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

final class CryptoCurrencyRemoteDataSource: CryptoCurrencyRemoteDataSourceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCryptoCurrencies() -> AnyPublisher<[CryptoCurrency], Error> {
        let endpoint = "\(baseURL)/coins/markets"
        let parameters = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "100",
            "page": "1",
            "sparkline": "false"
        ]
        
        return networkService.request(endpoint: endpoint, parameters: parameters)
            .decode(type: [CryptoCurrency].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchCryptoCurrency(by id: String) -> AnyPublisher<CryptoCurrency, Error> {
        let endpoint = "\(baseURL)/coins/\(id)"
        let parameters = [
            "localization": "false",
            "tickers": "false",
            "market_data": "true",
            "community_data": "false",
            "developer_data": "false",
            "sparkline": "false"
        ]
        
        return networkService.request(endpoint: endpoint, parameters: parameters)
            .decode(type: CryptoCurrency.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func searchCryptoCurrencies(query: String) -> AnyPublisher<[CryptoCurrency], Error> {
        let endpoint = "\(baseURL)/search"
        let parameters = ["query": query]
        
        return networkService.request(endpoint: endpoint, parameters: parameters)
            .decode(type: CryptoSearchResponse.self, decoder: JSONDecoder())
            .map { $0.coins.map { $0.toCryptoCurrency() } }
            .eraseToAnyPublisher()
    }
}

// MARK: - Search Response Models
private struct CryptoSearchResponse: Codable {
    let coins: [CryptoSearchCoin]
}

private struct CryptoSearchCoin: Codable {
    let id: String
    let name: String
    let symbol: String
    let marketCapRank: Int?
    
    func toCryptoCurrency() -> CryptoCurrency {
        // Cria um objeto básico para busca - dados completos precisariam de fetch individual
        return CryptoCurrency(
            id: id,
            symbol: symbol,
            name: name,
            image: "",
            currentPrice: 0,
            marketCap: 0,
            marketCapRank: marketCapRank ?? 0,
            fullyDilutedValuation: nil,
            totalVolume: 0,
            high24H: 0,
            low24H: 0,
            priceChange24H: 0,
            priceChangePercentage24H: 0,
            marketCapChange24H: 0,
            marketCapChangePercentage24H: 0,
            circulatingSupply: 0,
            totalSupply: nil,
            maxSupply: nil,
            ath: 0,
            athChangePercentage: 0,
            athDate: "",
            atl: 0,
            atlChangePercentage: 0,
            atlDate: "",
            roi: nil,
            lastUpdated: ""
        )
    }
}

// MARK: - CryptoCurrency Initializer Extension
extension CryptoCurrency {
    init(id: String, symbol: String, name: String, image: String, currentPrice: Double, marketCap: Double, marketCapRank: Int, fullyDilutedValuation: Double?, totalVolume: Double, high24H: Double, low24H: Double, priceChange24H: Double, priceChangePercentage24H: Double, marketCapChange24H: Double, marketCapChangePercentage24H: Double, circulatingSupply: Double, totalSupply: Double?, maxSupply: Double?, ath: Double, athChangePercentage: Double, athDate: String, atl: Double, atlChangePercentage: Double, atlDate: String, roi: ROI?, lastUpdated: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.roi = roi
        self.lastUpdated = lastUpdated
    }
}
