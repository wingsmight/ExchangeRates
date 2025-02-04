//
//  CurrencyAPIServiceProtocol.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

protocol CurrencyAPIServiceProtocol {
    func fetchRates(completion: @escaping (Result<[String: Double], Error>) -> Void)
}
