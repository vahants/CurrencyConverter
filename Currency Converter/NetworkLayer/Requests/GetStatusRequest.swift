//
//  GetStatusRequest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct GetStatusRequestData: Encodable {
    // Define your request data structure
}

struct GetStatusRequest: APIRequest {
    typealias RequestDataType = GetStatusRequestData
    typealias ResponseDataType = QuotasResponse

    func makeRequest(from data: GetStatusRequestData?, type: HttpMethod) throws -> URLComponents {
        guard let urlComponents = URLComponents(string: GetStatusProvider.Endpoint.status.urlString) else {
            throw ApplicationError.Network.General.badRequest
        }
        return urlComponents
    }
}
