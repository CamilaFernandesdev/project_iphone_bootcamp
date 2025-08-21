//
//  NetworkService.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Codable>(endpoint: String, parameters: [String: Any]) -> AnyPublisher<Data, Error> {
        guard let url = buildURL(endpoint: endpoint, parameters: parameters) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { error in
                NetworkError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func request<T: Codable>(endpoint: String, parameters: [String: Any]) -> AnyPublisher<T, Error> {
        return self.request(endpoint: endpoint, parameters: parameters)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError(error)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    private func buildURL(endpoint: String, parameters: [String: Any]) -> URL? {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return nil
        }
        
        let queryItems = parameters.compactMap { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erro ao decodificar dados: \(error.localizedDescription)"
        case .noData:
            return "Nenhum dado recebido"
        }
    }
}
