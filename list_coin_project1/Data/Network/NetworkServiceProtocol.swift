//
//  NetworkServiceProtocol.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: String, parameters: [String: Any]) -> AnyPublisher<Data, Error>
    func request<T: Codable>(endpoint: String, parameters: [String: Any]) -> AnyPublisher<T, Error>
}
