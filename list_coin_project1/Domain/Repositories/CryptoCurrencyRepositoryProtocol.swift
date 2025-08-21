//
//  CryptoCurrencyRepositoryProtocol.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

protocol CryptoCurrencyRepositoryProtocol {
    func fetchCryptoCurrencies() -> AnyPublisher<[CryptoCurrency], Error>
    func fetchCryptoCurrency(by id: String) -> AnyPublisher<CryptoCurrency, Error>
    func searchCryptoCurrencies(query: String) -> AnyPublisher<[CryptoCurrency], Error>
}
