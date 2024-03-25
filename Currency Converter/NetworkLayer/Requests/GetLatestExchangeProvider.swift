//
//  GetLatestExchangeProvider.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation


enum GetLatestExchangeProvider: LocalResources {
    /// API endpoints
    enum Endpoint {
        case latest
        /// Returns the API Endpoint URL as string for the current environment

        var urlString: String {
            switch self {
            case .latest:
                return "\(BackendEnvironment.apiCurrency.baseURL)/v1/latest"
            }
        }
    }

    static func getLatest(base_currency: String, currencies: String) async throws -> (LatestRates) {
        var queryItems: [String: String] = [:]
        if let items = makeQueryItems(base_currency: base_currency, currencies: currencies) {
            queryItems = items
        }
        let request = GetLatestExchangeRequest()
        let loader = APIRequestLoader(apiRequest: request)
        let response = try await loader.loadAPIDataRequest(requestData: nil, type: .get, parameters: queryItems)
        return response
    }
    
    static func makeQueryItems(base_currency: String, currencies: String) -> [String: String]? {
        var header = [String: String]()
        header["base_currency"] = base_currency
        header["currencies"] = currencies
        return header
    }
}
