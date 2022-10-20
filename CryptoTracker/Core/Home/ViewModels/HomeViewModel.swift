//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Dev C Krishna on 15/10/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink{ [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellabels)
        
        marketDataService.$marketData
                    .map(mapGlobalMarketData)
                    .sink { [weak self] (returnedStats) in
                        self?.statistics = returnedStats
                    }
                    .store(in: &cancellabels)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else{
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins  = returnedCoins
            }
            .store(in: &cancellabels)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else{
            return coins
        }
        let lowerCasedText = text.lowercased()
        return coins.filter{(coin) -> Bool in
            return coin.name.lowercased().contains(lowerCasedText) || coin.symbol.lowercased().contains(lowerCasedText)
            || coin.id.lowercased().contains(lowerCasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Porfolio Value", value: "$0.0", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
