//
//  CryptoListView.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import SwiftUI

struct CryptoListView: View {
    
    @StateObject private var viewModel: CryptoListViewModel
    @State private var showingRefreshIndicator = false
    
    init(viewModel: CryptoListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Content
                if viewModel.isLoading && viewModel.cryptocurrencies.isEmpty {
                    loadingView
                } else if viewModel.hasError && viewModel.cryptocurrencies.isEmpty {
                    errorView
                } else {
                    cryptoList
                }
            }
            .navigationTitle("Criptomoedas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
        }
        .onAppear {
            if viewModel.cryptocurrencies.isEmpty {
                viewModel.loadCryptoCurrencies()
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar criptomoedas...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Carregando criptomoedas...")
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Erro ao carregar dados")
                .font(.headline)
            
            Text(viewModel.errorMessage ?? "Tente novamente mais tarde")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Tentar Novamente") {
                viewModel.loadCryptoCurrencies()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Crypto List
    private var cryptoList: some View {
        List {
            ForEach(viewModel.filteredCryptocurrencies) { crypto in
                CryptoCurrencyRowView(cryptocurrency: crypto)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            await refreshData()
        }
    }
    
    // MARK: - Refresh Button
    private var refreshButton: some View {
        Button(action: {
            viewModel.refreshData()
        }) {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Private Methods
    private func refreshData() async {
        viewModel.refreshData()
    }
}

// MARK: - Preview
struct CryptoListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = MockFetchCryptoCurrenciesUseCase()
        let viewModel = CryptoListViewModel(fetchCryptoCurrenciesUseCase: mockUseCase)
        
        CryptoListView(viewModel: viewModel)
    }
}

// MARK: - Mock for Preview
private class MockFetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol {
    func execute() -> AnyPublisher<[CryptoCurrency], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
