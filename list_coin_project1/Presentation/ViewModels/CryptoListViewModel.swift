//
//  CryptoListViewModel.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import Foundation
import Combine

@MainActor
final class CryptoListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cryptocurrencies: [CryptoCurrency] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    // MARK: - Private Properties
    private let fetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var filteredCryptocurrencies: [CryptoCurrency] {
        if searchText.isEmpty {
            return cryptocurrencies
        }
        return cryptocurrencies.filter { crypto in
            crypto.name.lowercased().contains(searchText.lowercased()) ||
            crypto.symbol.lowercased().contains(searchText.lowercased())
        }
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
    
    // MARK: - Initializer
    init(fetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol) {
        self.fetchCryptoCurrenciesUseCase = fetchCryptoCurrenciesUseCase
        setupSearchSubscription()
    }
    
    // MARK: - Public Methods
    func loadCryptoCurrencies() {
        isLoading = true
        errorMessage = nil
        
        fetchCryptoCurrenciesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] cryptocurrencies in
                self?.cryptocurrencies = cryptocurrencies
            }
            .store(in: &cancellables)
    }
    
    func refreshData() {
        loadCryptoCurrencies()
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                // A busca é feita localmente através da computed property
                // Aqui poderíamos implementar busca na API se necessário
            }
            .store(in: &cancellables)
    }
}
