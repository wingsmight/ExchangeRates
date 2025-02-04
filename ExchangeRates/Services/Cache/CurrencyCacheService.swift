//
//  CurrencyCacheService.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import Foundation

final class CurrencyCacheService: CurrencyCacheServiceProtocol {
    private let cacheKey = "cachedCurrencyRates"

    func saveRates(_ rates: [String: Double]) {
        let data = try? JSONEncoder().encode(rates)
        UserDefaults.standard.set(data, forKey: cacheKey)
    }

    func loadRates() -> [String: Double]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode([String: Double].self, from: data)
    }
}
