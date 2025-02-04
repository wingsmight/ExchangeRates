//
//  CurrencyRepository.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import Foundation

final class CurrencyRepository: CurrencyRepositoryProtocol {
    private let apiService: CurrencyAPIServiceProtocol
    private let cacheService: CurrencyCacheServiceProtocol

    init(apiService: CurrencyAPIServiceProtocol, cacheService: CurrencyCacheServiceProtocol) {
        self.apiService = apiService
        self.cacheService = cacheService
    }

    func getRates(completion: @escaping (Result<[String: Double], CurrencyRepositoryError>) -> Void) {
        apiService.fetchRates { [weak self] result in
            switch result {
            case .success(let rates):
                self?.cacheService.saveRates(rates)
                completion(.success(rates))
            case .failure:
                if let cachedRates = self?.cacheService.loadRates() {
                    completion(.failure(.noInternet(rates: cachedRates)))
                } else {
                    completion(.failure(.noData))
                }
            }
        }
    }
}
