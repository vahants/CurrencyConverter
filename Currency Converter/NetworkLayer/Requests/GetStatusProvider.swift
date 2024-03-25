//
//  GetStatusProvider.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation


enum GetStatusProvider: LocalResources {
    /// API endpoints
    enum Endpoint {
        case status
        /// Returns the API Endpoint URL as string for the current environment

        var urlString: String {
            switch self {
            case .status:
                return "\(BackendEnvironment.apiCurrency.baseURL)/v1/status"
            }
        }
    }

    static func getStatus() async throws -> (Quotas) {
        let request = GetStatusRequest()
        let loader = APIRequestLoader(apiRequest: request)
        let response = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
        return response.quotas
    }
}
