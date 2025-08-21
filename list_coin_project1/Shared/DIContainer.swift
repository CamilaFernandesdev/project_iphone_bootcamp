//
//  DIContainer.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation

final class DIContainer {
    
    // MARK: - Shared Instance
    static let shared = DIContainer()
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Services
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkService()
    }()
    
    lazy var notificationService: NotificationService = {
        return NotificationService.shared
    }()
    
    lazy var coreDataManager: CoreDataManager = {
        return CoreDataManager.shared
    }()
    
    // MARK: - Data Sources
    lazy var remoteDataSource: CryptoCurrencyRemoteDataSourceProtocol = {
        return CryptoCurrencyRemoteDataSource(networkService: networkService)
    }()
    
    lazy var localDataSource: CryptoCurrencyLocalDataSourceProtocol = {
        return CryptoCurrencyLocalDataSource()
    }()
    
    // MARK: - Repositories
    lazy var cryptoCurrencyRepository: CryptoCurrencyRepositoryProtocol = {
        return CryptoCurrencyRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }()
    
    // MARK: - Use Cases
    lazy var fetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol = {
        return FetchCryptoCurrenciesUseCase(repository: cryptoCurrencyRepository)
    }()
    
    // MARK: - View Models
    func makeCryptoListViewModel() -> CryptoListViewModel {
        return CryptoListViewModel(fetchCryptoCurrenciesUseCase: fetchCryptoCurrenciesUseCase)
    }
    
    // MARK: - Configuration
    func configureServices() {
        // Request notification permissions
        notificationService.requestAuthorization()
        
        // Configure Core Data
        _ = coreDataManager.persistentContainer
        
        // Schedule default notifications
        notificationService.scheduleMarketUpdateNotification()
    }
}
