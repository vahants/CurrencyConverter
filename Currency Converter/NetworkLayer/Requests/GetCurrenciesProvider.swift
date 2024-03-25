//
//  GetCurrenciesProvider.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

enum GetCurrenciesProvider: LocalResources {
    /// API endpoints
    enum Endpoint {
        case currencies
        /// Returns the API Endpoint URL as string for the current environment

        var urlString: String {
            switch self {
            case .currencies:
                return "\(BackendEnvironment.apiCurrency.baseURL)/v1/currencies"
            }
        }
    }

    static func getCurrencies(currencies: String?) async throws -> (CurrencyResponse) {
        var queryItems: [String: String] = [:]
        if let currencies = currencies {
            if let items = makeQueryItems(currencies: currencies) {
                queryItems = items
            }
        }

        let request = GetCurrenciesRequest()
        let loader = APIRequestLoader(apiRequest: request)
        let response = try await loader.loadAPIDataRequest(requestData: nil, type: .get, parameters: queryItems)
        return response
    }
    
    static func makeQueryItems(currencies: String) -> [String: String]? {
        var header = [String: String]()
        header["currencies"] = currencies
        return header
    }
}
