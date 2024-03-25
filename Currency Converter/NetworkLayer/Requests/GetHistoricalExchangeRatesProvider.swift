//
//  GetHistoricalExchangeRatesProvider.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation


enum GetHistoricalExchangeRatesProvider: LocalResources {
    /// API endpoints
    enum Endpoint {
        case historical
        /// Returns the API Endpoint URL as string for the current environment

        var urlString: String {
            switch self {
            case .historical:
                return "\(BackendEnvironment.apiCurrency.baseURL)/v1/historical"
            }
        }
    }

    static func getHistoricalExchangeRate(date: String, base_currency: String, currencies: String) async throws -> ([String: [String: Double]]?) {
        var queryItems: [String: String] = [:]
        if let items = makeQueryItems(date: date, base_currency: base_currency, currencies: currencies) {
            queryItems = items
        }
        let request = GetHistoricalExchangeRatesRequest()
        let loader = APIRequestLoader(apiRequest: request)
        let response = try await loader.loadAPIDataRequest(requestData: nil, type: .get, parameters: queryItems)
        return response.data
    }
    
    static func makeQueryItems(date: String, base_currency: String, currencies: String) -> [String: String]? {
        var header = [String: String]()
        header["date"] = date
        header["base_currency"] = base_currency
        header["currencies"] = currencies
        return header
    }
}
