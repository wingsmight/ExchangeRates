//
//  CurrencyCacheServiceProtocol.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

protocol CurrencyCacheServiceProtocol {
    func saveRates(_ rates: [String: Double])
    func loadRates() -> [String: Double]?
}
