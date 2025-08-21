//
//  FetchCryptoCurrenciesUseCase.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

// MARK: - Protocol
protocol FetchCryptoCurrenciesUseCaseProtocol {
    func execute() -> AnyPublisher<[CryptoCurrency], Error>
}

// MARK: - Implementation
final class FetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol {
    
    private let repository: CryptoCurrencyRepositoryProtocol
    
    init(repository: CryptoCurrencyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[CryptoCurrency], Error> {
        return repository.fetchCryptoCurrencies()
    }
}
