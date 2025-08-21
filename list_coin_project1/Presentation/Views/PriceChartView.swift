//
//  PriceChartView.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import SwiftUI
import Charts

struct PriceChartView: View {
    
    let cryptocurrency: CryptoCurrency
    @State private var selectedTimeframe: Timeframe = .day
    @State private var priceData: [PriceDataPoint] = []
    @State private var isLoading = false
    
    enum Timeframe: String, CaseIterable {
        case hour = "1H"
        case day = "24H"
        case week = "7D"
        case month = "30D"
        
        var hours: Int {
            switch self {
            case .hour: return 1
            case .day: return 24
            case .week: return 168
            case .month: return 720
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            chartHeader
            
            // Chart
            if isLoading {
                loadingView
            } else if priceData.isEmpty {
                emptyChartView
            } else {
                chartView
            }
            
            // Timeframe Selector
            timeframeSelector
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            loadPriceData()
        }
        .onChange(of: selectedTimeframe) { _ in
            loadPriceData()
        }
    }
    
    // MARK: - Chart Header
    private var chartHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(cryptocurrency.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("$\(cryptocurrency.formattedCurrentPrice)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text(cryptocurrency.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: priceChangeIcon)
                        .font(.caption)
                        .foregroundColor(priceChangeColor)
                    
                    Text("\(priceChangePercentage, specifier: "%.2f")%")
                        .font(.subheadline)
                        .foregroundColor(priceChangeColor)
                }
            }
        }
    }
    
    // MARK: - Chart View
    private var chartView: some View {
        Chart(priceData) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Price", dataPoint.price)
            )
            .foregroundStyle(priceChangeColor.gradient)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            AreaMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Price", dataPoint.price)
            )
            .foregroundStyle(priceChangeColor.opacity(0.1).gradient)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(formatTimeLabel(date))
                            .font(.caption2)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                if let price = value.as(Double.self) {
                    AxisValueLabel {
                        Text("$\(price, specifier: "%.2f")")
                            .font(.caption2)
                    }
                }
            }
        }
        .frame(height: 200)
        .chartOverlay { proxy in
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let location = value.location
                            if let date = proxy.value(atX: location.x) as Date?,
                               let price = proxy.value(atY: location.y) as Double? {
                                // Handle chart interaction
                                print("Selected: \(date) - $\(price)")
                            }
                        }
                )
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text("Carregando dados do gráfico...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(height: 200)
    }
    
    // MARK: - Empty Chart View
    private var emptyChartView: some View {
        VStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("Nenhum dado disponível")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(height: 200)
    }
    
    // MARK: - Timeframe Selector
    private var timeframeSelector: some View {
        HStack(spacing: 0) {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                Button(action: {
                    selectedTimeframe = timeframe
                }) {
                    Text(timeframe.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedTimeframe == timeframe ? priceChangeColor : Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                if timeframe != Timeframe.allCases.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    // MARK: - Computed Properties
    private var priceChangeIcon: String {
        return cryptocurrency.priceChangePercentage24H >= 0 ? "arrow.up.right" : "arrow.down.right"
    }
    
    private var priceChangeColor: Color {
        return cryptocurrency.priceChangePercentage24H >= 0 ? .green : .red
    }
    
    private var priceChangePercentage: Double {
        return abs(cryptocurrency.priceChangePercentage24H)
    }
    
    // MARK: - Private Methods
    private func loadPriceData() {
        isLoading = true
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.priceData = self.generateMockPriceData()
            self.isLoading = false
        }
    }
    
    private func generateMockPriceData() -> [PriceDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .hour, value: -selectedTimeframe.hours, to: now) ?? now
        
        var data: [PriceDataPoint] = []
        let basePrice = cryptocurrency.currentPrice
        let volatility = basePrice * 0.05 // 5% volatility
        
        for i in 0..<selectedTimeframe.hours {
            let timestamp = calendar.date(byAdding: .hour, value: i, to: startDate) ?? now
            let randomChange = Double.random(in: -volatility...volatility)
            let price = basePrice + randomChange
            
            data.append(PriceDataPoint(timestamp: timestamp, price: max(0, price)))
        }
        
        return data
    }
    
    private func formatTimeLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        switch selectedTimeframe {
        case .hour:
            formatter.dateFormat = "HH:mm"
        case .day:
            formatter.dateFormat = "HH:mm"
        case .week:
            formatter.dateFormat = "MMM dd"
        case .month:
            formatter.dateFormat = "MMM dd"
        }
        
        return formatter.string(from: date)
    }
}

// MARK: - Price Data Point
struct PriceDataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let price: Double
}

// MARK: - Preview
struct PriceChartView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCrypto = CryptoCurrency(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
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
        )
        
        PriceChartView(cryptocurrency: mockCrypto)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
