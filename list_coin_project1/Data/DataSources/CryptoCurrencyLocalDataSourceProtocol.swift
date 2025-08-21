//
//  CryptoCurrencyLocalDataSourceProtocol.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation

protocol CryptoCurrencyLocalDataSourceProtocol {
    func saveCryptoCurrencies(_ cryptocurrencies: [CryptoCurrency])
    func saveCryptoCurrency(_ cryptocurrency: CryptoCurrency)
    func getCryptoCurrency(by id: String) -> CryptoCurrency?
    func searchCryptoCurrencies(query: String) -> [CryptoCurrency]
    func clearCache()
}
