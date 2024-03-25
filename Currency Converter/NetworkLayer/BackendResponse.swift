//
//  BackendResponse.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct ResponseStatus: Decodable  {
    let code: Int?
    let message: String?

    enum StatusKeys: String, CodingKey {
        case http
    }
}

/// Empty Data Response Type for response with no data
struct EmptyDataResponse: Decodable {}

/// General model for SSO responses
struct BackendResponse<T: Decodable>: Decodable {
    let status: ResponseStatus?
    let data: T?

    private enum CodingKeys: String, CodingKey {
        case status
        case data
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let statusContainer = try? rootContainer.nestedContainer(keyedBy: ResponseStatus.StatusKeys.self, forKey: .status)
        status = try? statusContainer?.decodeIfPresent(ResponseStatus.self, forKey: ResponseStatus.StatusKeys.http)

        // If decoding fails, just fallback to `nil`
        // This is needed, because backend sends other types for data in error cases
        data = try rootContainer.decodeIfPresent(T.self, forKey: .data)
    }
}
