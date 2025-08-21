//
//  CryptoCurrencyRepository.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

final class CryptoCurrencyRepository: CryptoCurrencyRepositoryProtocol {
    
    private let remoteDataSource: CryptoCurrencyRemoteDataSourceProtocol
    private let localDataSource: CryptoCurrencyLocalDataSourceProtocol
    
    init(remoteDataSource: CryptoCurrencyRemoteDataSourceProtocol,
         localDataSource: CryptoCurrencyLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchCryptoCurrencies() -> AnyPublisher<[CryptoCurrency], Error> {
        return remoteDataSource.fetchCryptoCurrencies()
            .handleEvents(receiveOutput: { [weak self] cryptocurrencies in
                // Cache local dos dados
                self?.localDataSource.saveCryptoCurrencies(cryptocurrencies)
            })
            .eraseToAnyPublisher()
    }
    
    func fetchCryptoCurrency(by id: String) -> AnyPublisher<CryptoCurrency, Error> {
        // Primeiro tenta buscar do cache local
        if let localCrypto = localDataSource.getCryptoCurrency(by: id) {
            return Just(localCrypto)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // Se não encontrar localmente, busca da API
        return remoteDataSource.fetchCryptoCurrency(by: id)
            .handleEvents(receiveOutput: { [weak self] cryptocurrency in
                self?.localDataSource.saveCryptoCurrency(cryptocurrency)
            })
            .eraseToAnyPublisher()
    }
    
    func searchCryptoCurrencies(query: String) -> AnyPublisher<[CryptoCurrency], Error> {
        // Busca local primeiro para resposta rápida
        let localResults = localDataSource.searchCryptoCurrencies(query: query)
        
        // Se encontrar resultados locais, retorna imediatamente
        if !localResults.isEmpty {
            return Just(localResults)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // Caso contrário, busca da API
        return remoteDataSource.searchCryptoCurrencies(query: query)
            .eraseToAnyPublisher()
    }
}
