//
//  ContentView.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: CryptoListViewModel
    
    init() {
        let diContainer = DIContainer.shared
        self._viewModel = StateObject(wrappedValue: diContainer.makeCryptoListViewModel())
    }
    
    var body: some View {
        CryptoListView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
