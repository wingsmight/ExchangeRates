//
//  CurrencyAPIService.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import Foundation

final class CurrencyAPIService: CurrencyAPIServiceProtocol {
    private let url = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_BCLK2df9Txb1pK0pHkHp7eUDlJSWOkRQibPPtnv8"

    func fetchRates(completion: @escaping (Result<[String: Double], Error>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CurrencyRate.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse.data)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
