//
//  CryptoCurrencyTests.swift
//  CryptoMarketAppTests
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import XCTest
@testable import list_coin_project1

final class CryptoCurrencyTests: XCTestCase {
    
    var mockCryptoCurrency: CryptoCurrency!
    
    override func setUp() {
        super.setUp()
        mockCryptoCurrency = createMockCryptoCurrency()
    }
    
    override func tearDown() {
        mockCryptoCurrency = nil
        super.tearDown()
    }
    
    // MARK: - Test Properties
    func testCryptoCurrencyProperties() {
        XCTAssertEqual(mockCryptoCurrency.id, "bitcoin")
        XCTAssertEqual(mockCryptoCurrency.symbol, "btc")
        XCTAssertEqual(mockCryptoCurrency.name, "Bitcoin")
        XCTAssertEqual(mockCryptoCurrency.currentPrice, 45000.0)
        XCTAssertEqual(mockCryptoCurrency.marketCap, 850000000000)
        XCTAssertEqual(mockCryptoCurrency.marketCapRank, 1)
    }
    
    // MARK: - Test Computed Properties
    func testFormattedCurrentPrice() {
        XCTAssertEqual(mockCryptoCurrency.formattedCurrentPrice, "45000.00")
    }
    
    func testFormattedMarketCap() {
        XCTAssertEqual(mockCryptoCurrency.formattedMarketCap, "850.00B")
    }
    
    func testFormattedVolume() {
        XCTAssertEqual(mockCryptoCurrency.formattedVolume, "25.00B")
    }
    
    func testPriceChangeColor() {
        XCTAssertEqual(mockCryptoCurrency.priceChangeColor, "green")
        
        let negativeCrypto = createMockCryptoCurrency(priceChangePercentage: -2.27)
        XCTAssertEqual(negativeCrypto.priceChangeColor, "red")
    }
    
    // MARK: - Test Codable
    func testCryptoCurrencyEncoding() {
        do {
            let data = try JSONEncoder().encode(mockCryptoCurrency)
            let decodedCrypto = try JSONDecoder().decode(CryptoCurrency.self, from: data)
            
            XCTAssertEqual(mockCryptoCurrency.id, decodedCrypto.id)
            XCTAssertEqual(mockCryptoCurrency.symbol, decodedCrypto.symbol)
            XCTAssertEqual(mockCryptoCurrency.name, decodedCrypto.name)
            XCTAssertEqual(mockCryptoCurrency.currentPrice, decodedCrypto.currentPrice)
        } catch {
            XCTFail("Encoding/Decoding failed with error: \(error)")
        }
    }
    
    func testCryptoCurrencyFromJSON() {
        let jsonString = """
        {
            "id": "ethereum",
            "symbol": "eth",
            "name": "Ethereum",
            "image": "https://example.com/eth.png",
            "current_price": 3000.0,
            "market_cap": 400000000000,
            "market_cap_rank": 2,
            "fully_diluted_valuation": null,
            "total_volume": 15000000000,
            "high_24h": 3100.0,
            "low_24h": 2900.0,
            "price_change_24h": 100.0,
            "price_change_percentage_24h": 3.45,
            "market_cap_change_24h": 15000000000,
            "market_cap_change_percentage_24h": 3.9,
            "circulating_supply": 120000000,
            "total_supply": 120000000,
            "max_supply": 120000000,
            "ath": 5000.0,
            "ath_change_percentage": -40.0,
            "ath_date": "2021-11-10T14:24:11.849Z",
            "atl": 0.432,
            "atl_change_percentage": 694444.44,
            "atl_date": "2015-10-20T00:00:00.000Z",
            "roi": null,
            "last_updated": "2023-10-22T10:00:00.000Z"
        }
        """
        
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let crypto = try JSONDecoder().decode(CryptoCurrency.self, from: jsonData)
            
            XCTAssertEqual(crypto.id, "ethereum")
            XCTAssertEqual(crypto.symbol, "eth")
            XCTAssertEqual(crypto.name, "Ethereum")
            XCTAssertEqual(crypto.currentPrice, 3000.0)
            XCTAssertEqual(crypto.marketCap, 400000000000)
        } catch {
            XCTFail("JSON decoding failed with error: \(error)")
        }
    }
    
    // MARK: - Test Edge Cases
    func testZeroValues() {
        let zeroCrypto = createMockCryptoCurrency(
            currentPrice: 0,
            marketCap: 0,
            totalVolume: 0
        )
        
        XCTAssertEqual(zeroCrypto.formattedCurrentPrice, "0.00")
        XCTAssertEqual(zeroCrypto.formattedMarketCap, "0")
        XCTAssertEqual(zeroCrypto.formattedVolume, "0")
    }
    
    func testLargeNumbers() {
        let largeCrypto = createMockCryptoCurrency(
            marketCap: 999999999999999,
            totalVolume: 1234567890123
        )
        
        XCTAssertEqual(largeCrypto.formattedMarketCap, "999999.99T")
        XCTAssertEqual(largeCrypto.formattedVolume, "1234.57T")
    }
    
    // MARK: - Helper Methods
    private func createMockCryptoCurrency(
        id: String = "bitcoin",
        symbol: String = "btc",
        name: String = "Bitcoin",
        currentPrice: Double = 45000.0,
        marketCap: Double = 850000000000,
        totalVolume: Double = 25000000000,
        priceChangePercentage: Double = 2.27
    ) -> CryptoCurrency {
        return CryptoCurrency(
            id: id,
            symbol: symbol,
            name: name,
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: 1,
            fullyDilutedValuation: nil,
            totalVolume: totalVolume,
            high24H: 46000.0,
            low24H: 44000.0,
            priceChange24H: 1000.0,
            priceChangePercentage24H: priceChangePercentage,
            marketCapChange24H: 20000000000,
            marketCapChangePercentage24H: 2.4,
            circulatingSupply: 19000000,
            totalSupply: 21000000,
            maxSupply: 21000000,
            ath: 69000.0,
            athChangePercentage: -34.78,
            athDate: "2021-11-10T14:24:11.849Z",
            atl: 67.81,
            atlChangePercentage: 66235.74,
            atlDate: "2013-07-06T00:00:00.000Z",
            roi: nil,
            lastUpdated: "2023-10-22T10:00:00.000Z"
        )
    }
}
