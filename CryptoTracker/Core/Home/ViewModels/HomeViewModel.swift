//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Dev C Krishna on 15/10/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellabels)
    }
}
