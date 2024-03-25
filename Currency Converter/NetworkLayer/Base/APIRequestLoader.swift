//
//  APIRequestLoader.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

final class APIRequestLoader<T: APIRequest> {
    let apiRequest: T
    let urlSession: URLSession

    private var additionalHeaders: [String: String]?

    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }

    func createHeaders() -> [String: Any] {
        var headers = ["Content-Type": "application/json"]
        if let additionalHeaders = self.additionalHeaders {
            for header in additionalHeaders {
                headers[header.key] = header.value
            }
        }
        return headers
    }
    
    func loadAPIDataRequest(requestData: T.RequestDataType?, type: HttpMethod, parameters: [String: String] = [:], headers: [String: String] = [:]) async throws -> T.ResponseDataType {
        do {
            var urlComponents = try apiRequest.makeRequest(from: requestData, type: type)

            var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            queryItems.append(URLQueryItem(name: "apikey", value: "fca_live_28oKN8vNKTAavKao6Tsj2x2onAkWq6lWYlQsYDL0"))

            urlComponents.queryItems = queryItems

            var request = URLRequest(url: (urlComponents.url)!)
            request.httpMethod = type.rawValue

            additionalHeaders = headers
            
            createHeaders().forEach { key, value in
                if let value = value as? String {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            // Encode model
            if let requestData = requestData {
                guard let encodedModel = try? JSONEncoder().encode(requestData) else {
                    assertionFailure("Model is not encoded")
                    throw ApplicationError.Network.General.encodingFailure
                }
                
                request.httpBody = encodedModel
            }
            
            let (data, response) = try await urlSession.data(for: request, delegate: nil)
            
            switch (response as? HTTPURLResponse)?.statusCode ?? 999 {
            case 200:
                let parseResponse = try apiRequest.parseResponse(data: data)
                return parseResponse
            case 400:
                throw ApplicationError.Network.General.badRequest
            case 401:
                throw ApplicationError.Network.General.notAuthorised
            case 403:
                throw ApplicationError.Network.General.notAllowed
            case 404:
                throw ApplicationError.Network.General.nonExist
            case 422:
                throw ApplicationError.Network.General.validationError
            case 500:
                throw ApplicationError.Network.General.serverError
            default:
                throw ApplicationError.Network.General.unknown
            }
        } catch {
            throw error
        }
    }
}
