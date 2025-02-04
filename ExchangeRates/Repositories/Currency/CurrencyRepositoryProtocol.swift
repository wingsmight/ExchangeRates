//
//  CurrencyRepositoryProtocol.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

protocol CurrencyRepositoryProtocol {
    func getRates(completion: @escaping (Result<[String: Double], CurrencyRepositoryError>) -> Void)
}

enum CurrencyRepositoryError: Error {
    case noData
    case noInternet(rates: [String: Double])
}
