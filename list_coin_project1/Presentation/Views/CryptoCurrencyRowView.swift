//
//  CryptoCurrencyRowView.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import SwiftUI

struct CryptoCurrencyRowView: View {
    
    let cryptocurrency: CryptoCurrency
    
    var body: some View {
        HStack(spacing: 16) {
            // Crypto Icon
            cryptoIcon
            
            // Crypto Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(cryptocurrency.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("(\(cryptocurrency.symbol.uppercased()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Rank #\(cryptocurrency.marketCapRank)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Vol: \(cryptocurrency.formattedVolume)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Price Info
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(cryptocurrency.formattedCurrentPrice)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
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
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
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
    
    // MARK: - Crypto Icon
    private var cryptoIcon: some View {
        AsyncImage(url: URL(string: cryptocurrency.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    Text(cryptocurrency.symbol.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                )
        }
        .frame(width: 40, height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview
struct CryptoCurrencyRowView_Previews: PreviewProvider {
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
        
        CryptoCurrencyRowView(cryptocurrency: mockCrypto)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
