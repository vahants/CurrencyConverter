//
//  GetCurrenciesRequest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct GetCurrenciesRequestData: Encodable {
    // Define your request data structure
}

struct GetCurrenciesRequest: APIRequest {
    typealias RequestDataType = GetCurrenciesRequestData
    typealias ResponseDataType = CurrencyResponse

    func makeRequest(from data: GetCurrenciesRequestData?, type: HttpMethod) throws -> URLComponents {
        guard let urlComponents = URLComponents(string: GetCurrenciesProvider.Endpoint.currencies.urlString) else {
            throw ApplicationError.Network.General.badRequest
        }
        return urlComponents
    }
}
