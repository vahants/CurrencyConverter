//
//  APIRequest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch   = "PATCH"
}

protocol APIRequest  {
    associatedtype ResponseDataType: Decodable
    associatedtype RequestDataType: Encodable
    func makeRequest(from data: RequestDataType?, type: HttpMethod) throws -> URLComponents
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension APIRequest {
    func parseResponse(data: Data) throws -> ResponseDataType {
        return try JSONDecoder().decode(ResponseDataType.self, from: data)
    }
}
