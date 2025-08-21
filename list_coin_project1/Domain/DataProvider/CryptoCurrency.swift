//
//  CryptoCurrency.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation

// MARK: - CryptoCurrency
struct CryptoCurrency: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int
    let fullyDilutedValuation: Double?
    let totalVolume: Double
    let high24H: Double
    let low24H: Double
    let priceChange24H: Double
    let priceChangePercentage24H: Double
    let marketCapChange24H: Double
    let marketCapChangePercentage24H: Double
    let circulatingSupply: Double
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double
    let athChangePercentage: Double
    let athDate: String
    let atl: Double
    let atlChangePercentage: Double
    let atlDate: String
    let roi: ROI?
    let lastUpdated: String
    
    // MARK: - Computed Properties
    var formattedCurrentPrice: String {
        return String(format: "%.2f", currentPrice)
    }
    
    var formattedMarketCap: String {
        return formatLargeNumber(marketCap)
    }
    
    var formattedVolume: String {
        return formatLargeNumber(totalVolume)
    }
    
    var priceChangeColor: String {
        return priceChangePercentage24H >= 0 ? "green" : "red"
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
    }
    
    // MARK: - Initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        marketCap = try container.decode(Double.self, forKey: .marketCap)
        marketCapRank = try container.decode(Int.self, forKey: .marketCapRank)
        fullyDilutedValuation = try container.decodeIfPresent(Double.self, forKey: .fullyDilutedValuation)
        totalVolume = try container.decode(Double.self, forKey: .totalVolume)
        high24H = try container.decode(Double.self, forKey: .high24H)
        low24H = try container.decode(Double.self, forKey: .low24H)
        priceChange24H = try container.decode(Double.self, forKey: .priceChange24H)
        priceChangePercentage24H = try container.decode(Double.self, forKey: .priceChangePercentage24H)
        marketCapChange24H = try container.decode(Double.self, forKey: .marketCapChange24H)
        marketCapChangePercentage24H = try container.decode(Double.self, forKey: .marketCapChangePercentage24H)
        circulatingSupply = try container.decode(Double.self, forKey: .circulatingSupply)
        totalSupply = try container.decodeIfPresent(Double.self, forKey: .totalSupply)
        maxSupply = try container.decodeIfPresent(Double.self, forKey: .maxSupply)
        ath = try container.decode(Double.self, forKey: .ath)
        athChangePercentage = try container.decode(Double.self, forKey: .athChangePercentage)
        athDate = try container.decode(String.self, forKey: .athDate)
        atl = try container.decode(Double.self, forKey: .atl)
        atlChangePercentage = try container.decode(Double.self, forKey: .atlChangePercentage)
        atlDate = try container.decode(String.self, forKey: .atlDate)
        roi = try container.decodeIfPresent(ROI.self, forKey: .roi)
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
    }
    
    // MARK: - Private Methods
    private func formatLargeNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if number >= 1_000_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000_000)) ?? "")B"
        } else if number >= 1_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000)) ?? "")M"
        } else if number >= 1_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000)) ?? "")K"
        } else {
            return formatter.string(from: NSNumber(value: number)) ?? "0"
        }
    }
}

// MARK: - ROI
struct ROI: Codable {
    let times: Double
    let currency: String
    let percentage: Double
}

// MARK: - CryptoCurrencyResponse
struct CryptoCurrencyResponse: Codable {
    let cryptocurrencies: [CryptoCurrency]
    
    enum CodingKeys: String, CodingKey {
        case cryptocurrencies = "data"
    }
}
