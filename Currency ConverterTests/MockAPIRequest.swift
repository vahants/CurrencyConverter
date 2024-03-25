//
//  MockAPIRequest.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation
@testable import Currency_Converter

struct MockAPIRequest: APIRequest {
    typealias RequestDataType = [String: String]
    typealias ResponseDataType = MockResponseData
    
    func createHeaders(with additionalHeaders: [String: String]?) -> [String: String] {
        var headers = ["Content-Type": "application/json"]

        // Merge additional headers if provided
        additionalHeaders?.forEach { key, value in
            headers[key] = value
        }
        
        return headers
    }


    func makeRequest(from data: RequestDataType?, type: HttpMethod) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "mockapi.com"
        components.path = "/test"
        return components
    }

    func parseResponse(data: Data) throws -> MockResponseData {
        let decoder = JSONDecoder()
        return try decoder.decode(MockResponseData.self, from: data)
    }
}

struct MockResponseData: Codable {
    let message: String
}
