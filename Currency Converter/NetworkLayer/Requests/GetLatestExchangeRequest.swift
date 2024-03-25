//
//  GetLatestExchangeRequest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct GetLatestExchangeRequestData: Encodable {
    // Define your request data structure
}

struct GetLatestExchangeRequest: APIRequest {
    typealias RequestDataType = GetLatestExchangeRequestData
    typealias ResponseDataType = LatestRates

    func makeRequest(from data: GetLatestExchangeRequestData?, type: HttpMethod) throws -> URLComponents {
        guard let urlComponents = URLComponents(string: GetLatestExchangeProvider.Endpoint.latest.urlString) else {
            throw ApplicationError.Network.General.badRequest
        }
        return urlComponents
    }
}
