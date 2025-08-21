//
//  CryptoListViewModelTests.swift
//  CryptoMarketAppTests
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import XCTest
import Combine
@testable import list_coin_project1

@MainActor
final class CryptoListViewModelTests: XCTestCase {
    
    var viewModel: CryptoListViewModel!
    var mockUseCase: MockFetchCryptoCurrenciesUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCryptoCurrenciesUseCase()
        viewModel = CryptoListViewModel(fetchCryptoCurrenciesUseCase: mockUseCase)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Initial State
    func testInitialState() {
        XCTAssertTrue(viewModel.cryptocurrencies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertFalse(viewModel.hasError)
    }
    
    // MARK: - Test Loading Success
    func testLoadCryptoCurrenciesSuccess() {
        // Given
        let expectedCryptos = createMockCryptoCurrencies()
        mockUseCase.mockResult = .success(expectedCryptos)
        
        // When
        viewModel.loadCryptoCurrencies()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for async operation
        let expectation = XCTestExpectation(description: "Load cryptocurrencies")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.cryptocurrencies.count, expectedCryptos.count)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.hasError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Test Loading Failure
    func testLoadCryptoCurrenciesFailure() {
        // Given
        let expectedError = NetworkError.invalidURL
        mockUseCase.mockResult = .failure(expectedError)
        
        // When
        viewModel.loadCryptoCurrencies()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for async operation
        let expectation = XCTestExpectation(description: "Load cryptocurrencies failure")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.cryptocurrencies.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, expectedError.localizedDescription)
            XCTAssertTrue(self.viewModel.hasError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Test Search Functionality
    func testSearchFunctionality() {
        // Given
        let cryptos = createMockCryptoCurrencies()
        viewModel.cryptocurrencies = cryptos
        
        // When - Search for "Bitcoin"
        viewModel.searchText = "Bitcoin"
        
        // Then
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 1)
        XCTAssertEqual(viewModel.filteredCryptocurrencies.first?.name, "Bitcoin")
        
        // When - Search for "ETH"
        viewModel.searchText = "ETH"
        
        // Then
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 1)
        XCTAssertEqual(viewModel.filteredCryptocurrencies.first?.symbol, "eth")
        
        // When - Empty search
        viewModel.searchText = ""
        
        // Then
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 3)
    }
    
    // MARK: - Test Search Case Insensitive
    func testSearchCaseInsensitive() {
        // Given
        let cryptos = createMockCryptoCurrencies()
        viewModel.cryptocurrencies = cryptos
        
        // When
        viewModel.searchText = "bitcoin"
        
        // Then
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 1)
        XCTAssertEqual(viewModel.filteredCryptocurrencies.first?.name, "Bitcoin")
        
        // When
        viewModel.searchText = "BTC"
        
        // Then
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 1)
        XCTAssertEqual(viewModel.filteredCryptocurrencies.first?.symbol, "btc")
    }
    
    // MARK: - Test Refresh Data
    func testRefreshData() {
        // Given
        let cryptos = createMockCryptoCurrencies()
        mockUseCase.mockResult = .success(cryptos)
        
        // When
        viewModel.refreshData()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        let expectation = XCTestExpectation(description: "Refresh data")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.cryptocurrencies.count, cryptos.count)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Test Clear Error
    func testClearError() {
        // Given
        viewModel.errorMessage = "Test error"
        
        // When
        viewModel.clearError()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.hasError)
    }
    
    // MARK: - Test Search Debounce
    func testSearchDebounce() {
        // Given
        let cryptos = createMockCryptoCurrencies()
        viewModel.cryptocurrencies = cryptos
        
        // When - Rapid search changes
        viewModel.searchText = "B"
        viewModel.searchText = "Bi"
        viewModel.searchText = "Bit"
        viewModel.searchText = "Bitc"
        viewModel.searchText = "Bitco"
        viewModel.searchText = "Bitcoin"
        
        // Then - Should filter correctly
        XCTAssertEqual(viewModel.filteredCryptocurrencies.count, 1)
        XCTAssertEqual(viewModel.filteredCryptocurrencies.first?.name, "Bitcoin")
    }
    
    // MARK: - Helper Methods
    private func createMockCryptoCurrencies() -> [CryptoCurrency] {
        return [
            CryptoCurrency(
                id: "bitcoin",
                symbol: "btc",
                name: "Bitcoin",
                image: "https://example.com/btc.png",
                currentPrice: 45000.0,
                marketCap: 850000000000,
                marketCapRank: 1,
                fullyDilutedValuation: nil,
                totalVolume: 25000000000,
                high24H: 46000.0,
                low24H: 44000.0,
                priceChange24H: 1000.0,
                priceChangePercentage24H: 2.27,
                marketCapChange24H: 20000000000,
                marketCapChangePercentage24H: 2.4,
                circulatingSupply: 19000000,
                totalSupply: 21000000,
                maxSupply: 21000000,
                ath: 69000.0,
                athChangePercentage: -34.78,
                athDate: "2021-11-10T14:24:11.849Z",
                atl: 67.81,
                atlChangePercentage: 66235.74,
                atlDate: "2013-07-06T00:00:00.000Z",
                roi: nil,
                lastUpdated: "2023-10-22T10:00:00.000Z"
            ),
            CryptoCurrency(
                id: "ethereum",
                symbol: "eth",
                name: "Ethereum",
                image: "https://example.com/eth.png",
                currentPrice: 3000.0,
                marketCap: 400000000000,
                marketCapRank: 2,
                fullyDilutedValuation: nil,
                totalVolume: 15000000000,
                high24H: 3100.0,
                low24H: 2900.0,
                priceChange24H: 100.0,
                priceChangePercentage24H: 3.45,
                marketCapChange24H: 15000000000,
                marketCapChangePercentage24H: 3.9,
                circulatingSupply: 120000000,
                totalSupply: 120000000,
                maxSupply: 120000000,
                ath: 5000.0,
                athChangePercentage: -40.0,
                athDate: "2021-11-10T14:24:11.849Z",
                atl: 0.432,
                atlChangePercentage: 694444.44,
                atlDate: "2015-10-20T00:00:00.000Z",
                roi: nil,
                lastUpdated: "2023-10-22T10:00:00.000Z"
            ),
            CryptoCurrency(
                id: "cardano",
                symbol: "ada",
                name: "Cardano",
                image: "https://example.com/ada.png",
                currentPrice: 0.5,
                marketCap: 20000000000,
                marketCapRank: 8,
                fullyDilutedValuation: nil,
                totalVolume: 500000000,
                high24H: 0.52,
                low24H: 0.48,
                priceChange24H: 0.02,
                priceChangePercentage24H: 4.17,
                marketCapChange24H: 1000000000,
                marketCapChangePercentage24H: 5.26,
                circulatingSupply: 40000000000,
                totalSupply: 45000000000,
                maxSupply: 45000000000,
                ath: 3.10,
                athChangePercentage: -83.87,
                athDate: "2021-09-02T06:00:10.474Z",
                atl: 0.017,
                atlChangePercentage: 2841.18,
                atlDate: "2020-03-13T02:22:55.044Z",
                roi: nil,
                lastUpdated: "2023-10-22T10:00:00.000Z"
            )
        ]
    }
}

// MARK: - Mock Use Case
final class MockFetchCryptoCurrenciesUseCase: FetchCryptoCurrenciesUseCaseProtocol {
    
    var mockResult: Result<[CryptoCurrency], Error> = .success([])
    
    func execute() -> AnyPublisher<[CryptoCurrency], Error> {
        switch mockResult {
        case .success(let cryptos):
            return Just(cryptos)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
