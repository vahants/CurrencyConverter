//
//  GetHistoricalExchangeRatesRequest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation


struct GetHistoricalExchangeRatesRequestData: Encodable {
    // Define your request data structure
}

struct GetHistoricalExchangeRatesRequest: APIRequest {
    typealias RequestDataType = GetHistoricalExchangeRatesRequestData
    typealias ResponseDataType = HistoricalCurrencyRates

    func makeRequest(from data: GetHistoricalExchangeRatesRequestData?, type: HttpMethod) throws -> URLComponents {
        guard let urlComponents = URLComponents(string: GetHistoricalExchangeRatesProvider.Endpoint.historical.urlString) else {
            throw ApplicationError.Network.General.badRequest
        }
        return urlComponents
    }
}
