//
//  URLSessionMock.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

extension URLSession: LocalResources {

    static func sessionConfigurationMocked(url: URL,  data: Data) -> URLSession {
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let error: Error? = nil

        URLProtocolMock.mockResponses = [url: (data, response, error)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: sessionConfiguration)
    }

}
