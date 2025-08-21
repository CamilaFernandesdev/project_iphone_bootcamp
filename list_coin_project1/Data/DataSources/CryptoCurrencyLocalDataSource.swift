//
//  CryptoCurrencyLocalDataSource.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation

final class CryptoCurrencyLocalDataSource: CryptoCurrencyLocalDataSourceProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let cryptoCurrenciesKey = "cached_crypto_currencies"
    private let cacheExpirationKey = "crypto_cache_expiration"
    private let cacheExpirationTime: TimeInterval = 300 // 5 minutos
    
    func saveCryptoCurrencies(_ cryptocurrencies: [CryptoCurrency]) {
        do {
            let data = try JSONEncoder().encode(cryptocurrencies)
            userDefaults.set(data, forKey: cryptoCurrenciesKey)
            userDefaults.set(Date().timeIntervalSince1970, forKey: cacheExpirationKey)
        } catch {
            print("Erro ao salvar criptomoedas no cache: \(error)")
        }
    }
    
    func saveCryptoCurrency(_ cryptocurrency: CryptoCurrency) {
        var cryptocurrencies = getAllCachedCryptoCurrencies()
        
        // Remove se já existir
        cryptocurrencies.removeAll { $0.id == cryptocurrency.id }
        
        // Adiciona no início
        cryptocurrencies.insert(cryptocurrency, at: 0)
        
        // Mantém apenas os últimos 100
        if cryptocurrencies.count > 100 {
            cryptocurrencies = Array(cryptocurrencies.prefix(100))
        }
        
        saveCryptoCurrencies(cryptocurrencies)
    }
    
    func getCryptoCurrency(by id: String) -> CryptoCurrency? {
        guard !isCacheExpired() else { return nil }
        
        let cryptocurrencies = getAllCachedCryptoCurrencies()
        return cryptocurrencies.first { $0.id == id }
    }
    
    func searchCryptoCurrencies(query: String) -> [CryptoCurrency] {
        guard !isCacheExpired() else { return [] }
        
        let cryptocurrencies = getAllCachedCryptoCurrencies()
        let lowercasedQuery = query.lowercased()
        
        return cryptocurrencies.filter { crypto in
            crypto.name.lowercased().contains(lowercasedQuery) ||
            crypto.symbol.lowercased().contains(lowercasedQuery)
        }
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: cryptoCurrenciesKey)
        userDefaults.removeObject(forKey: cacheExpirationKey)
    }
    
    // MARK: - Private Methods
    private func getAllCachedCryptoCurrencies() -> [CryptoCurrency] {
        guard let data = userDefaults.data(forKey: cryptoCurrenciesKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([CryptoCurrency].self, from: data)
        } catch {
            print("Erro ao decodificar criptomoedas do cache: \(error)")
            return []
        }
    }
    
    private func isCacheExpired() -> Bool {
        let lastUpdate = userDefaults.double(forKey: cacheExpirationKey)
        let currentTime = Date().timeIntervalSince1970
        return (currentTime - lastUpdate) > cacheExpirationTime
    }
}
