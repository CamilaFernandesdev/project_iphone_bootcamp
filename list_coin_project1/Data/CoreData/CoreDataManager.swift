//
//  CoreDataManager.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import CoreData
import Foundation

final class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptoMarketApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveBackgroundContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving background context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Crypto Currency Operations
    func saveCryptoCurrency(_ crypto: CryptoCurrency) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            // Check if entity already exists
            let fetchRequest: NSFetchRequest<CryptoCurrencyEntity> = CryptoCurrencyEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", crypto.id)
            
            do {
                let existingEntities = try self.backgroundContext.fetch(fetchRequest)
                let entity: CryptoCurrencyEntity
                
                if let existingEntity = existingEntities.first {
                    // Update existing entity
                    entity = existingEntity
                } else {
                    // Create new entity
                    entity = CryptoCurrencyEntity(context: self.backgroundContext)
                }
                
                // Update entity properties
                entity.id = crypto.id
                entity.symbol = crypto.symbol
                entity.name = crypto.name
                entity.image = crypto.image
                entity.currentPrice = crypto.currentPrice
                entity.marketCap = crypto.marketCap
                entity.marketCapRank = Int32(crypto.marketCapRank)
                entity.fullyDilutedValuation = crypto.fullyDilutedValuation
                entity.totalVolume = crypto.totalVolume
                entity.high24H = crypto.high24H
                entity.low24H = crypto.low24H
                entity.priceChange24H = crypto.priceChange24H
                entity.priceChangePercentage24H = crypto.priceChangePercentage24H
                entity.marketCapChange24H = crypto.marketCapChange24H
                entity.marketCapChangePercentage24H = crypto.marketCapChangePercentage24H
                entity.circulatingSupply = crypto.circulatingSupply
                entity.totalSupply = crypto.totalSupply
                entity.maxSupply = crypto.maxSupply
                entity.ath = crypto.ath
                entity.athChangePercentage = crypto.athChangePercentage
                entity.athDate = crypto.athDate
                entity.atl = crypto.atl
                entity.atlChangePercentage = crypto.atlChangePercentage
                entity.atlDate = crypto.atlDate
                entity.lastUpdated = crypto.lastUpdated
                entity.timestamp = Date()
                
                // Save price history
                self.savePriceHistory(for: crypto.id, price: crypto.currentPrice)
                
                self.saveBackgroundContext()
                
            } catch {
                print("Error saving crypto currency: \(error)")
            }
        }
    }
    
    func saveCryptoCurrencies(_ cryptos: [CryptoCurrency]) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            for crypto in cryptos {
                self.saveCryptoCurrency(crypto)
            }
        }
    }
    
    func fetchCryptoCurrencies() -> [CryptoCurrency] {
        let fetchRequest: NSFetchRequest<CryptoCurrencyEntity> = CryptoCurrencyEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "marketCapRank", ascending: true)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let id = entity.id,
                      let symbol = entity.symbol,
                      let name = entity.name,
                      let image = entity.image,
                      let lastUpdated = entity.lastUpdated else {
                    return nil
                }
                
                return CryptoCurrency(
                    id: id,
                    symbol: symbol,
                    name: name,
                    image: image,
                    currentPrice: entity.currentPrice,
                    marketCap: entity.marketCap,
                    marketCapRank: Int(entity.marketCapRank),
                    fullyDilutedValuation: entity.fullyDilutedValuation,
                    totalVolume: entity.totalVolume,
                    high24H: entity.high24H,
                    low24H: entity.low24H,
                    priceChange24H: entity.priceChange24H,
                    priceChangePercentage24H: entity.priceChangePercentage24H,
                    marketCapChange24H: entity.marketCapChange24H,
                    marketCapChangePercentage24H: entity.marketCapChangePercentage24H,
                    circulatingSupply: entity.circulatingSupply,
                    totalSupply: entity.totalSupply,
                    maxSupply: entity.maxSupply,
                    ath: entity.ath,
                    athChangePercentage: entity.athChangePercentage,
                    athDate: entity.athDate ?? "",
                    atl: entity.atl,
                    atlChangePercentage: entity.atlChangePercentage,
                    atlDate: entity.atlDate ?? "",
                    roi: nil,
                    lastUpdated: lastUpdated
                )
            }
        } catch {
            print("Error fetching crypto currencies: \(error)")
            return []
        }
    }
    
    func searchCryptoCurrencies(query: String) -> [CryptoCurrency] {
        let fetchRequest: NSFetchRequest<CryptoCurrencyEntity> = CryptoCurrencyEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "name CONTAINS[cd] %@ OR symbol CONTAINS[cd] %@",
            query, query
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "marketCapRank", ascending: true)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let id = entity.id,
                      let symbol = entity.symbol,
                      let name = entity.name,
                      let image = entity.image,
                      let lastUpdated = entity.lastUpdated else {
                    return nil
                }
                
                return CryptoCurrency(
                    id: id,
                    symbol: symbol,
                    name: name,
                    image: image,
                    currentPrice: entity.currentPrice,
                    marketCap: entity.marketCap,
                    marketCapRank: Int(entity.marketCapRank),
                    fullyDilutedValuation: entity.fullyDilutedValuation,
                    totalVolume: entity.totalVolume,
                    high24H: entity.high24H,
                    low24H: entity.low24H,
                    priceChange24H: entity.priceChange24H,
                    priceChangePercentage24H: entity.priceChangePercentage24H,
                    marketCapChange24H: entity.marketCapChange24H,
                    marketCapChangePercentage24H: entity.marketCapChangePercentage24H,
                    circulatingSupply: entity.circulatingSupply,
                    totalSupply: entity.totalSupply,
                    maxSupply: entity.maxSupply,
                    ath: entity.ath,
                    athChangePercentage: entity.athChangePercentage,
                    athDate: entity.athDate ?? "",
                    atl: entity.atl,
                    atlChangePercentage: entity.atlChangePercentage,
                    atlDate: entity.atlDate ?? "",
                    roi: nil,
                    lastUpdated: lastUpdated
                )
            }
        } catch {
            print("Error searching crypto currencies: \(error)")
            return []
        }
    }
    
    func clearAllData() {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            let cryptoFetchRequest: NSFetchRequest<NSFetchRequestResult> = CryptoCurrencyEntity.fetchRequest()
            let priceHistoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = PriceHistoryEntity.fetchRequest()
            
            let cryptoDeleteRequest = NSBatchDeleteRequest(fetchRequest: cryptoFetchRequest)
            let priceHistoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: priceHistoryFetchRequest)
            
            do {
                try self.backgroundContext.execute(cryptoDeleteRequest)
                try self.backgroundContext.execute(priceHistoryDeleteRequest)
                self.saveBackgroundContext()
            } catch {
                print("Error clearing data: \(error)")
            }
        }
    }
    
    // MARK: - Price History Operations
    private func savePriceHistory(for cryptoId: String, price: Double) {
        let entity = PriceHistoryEntity(context: backgroundContext)
        entity.cryptoId = cryptoId
        entity.price = price
        entity.timestamp = Date()
    }
    
    func fetchPriceHistory(for cryptoId: String, hours: Int = 24) -> [PriceHistoryEntity] {
        let fetchRequest: NSFetchRequest<PriceHistoryEntity> = PriceHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cryptoId == %@", cryptoId)
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .hour, value: -hours, to: Date()) ?? Date()
        fetchRequest.predicate = NSPredicate(
            format: "cryptoId == %@ AND timestamp >= %@",
            cryptoId, startDate as NSDate
        )
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching price history: \(error)")
            return []
        }
    }
}
