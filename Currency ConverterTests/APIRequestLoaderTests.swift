//
//  APIRequestLoaderTests.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

import XCTest
@testable import Currency_Converter

class APIRequestLoaderTests<T: APIRequest>: XCTestCase {
    let apiRequest: T
    
    var loader: APIRequestLoader<MockAPIRequest>!
    var urlSession: URLSession!
    
    private var additionalHeaders: [String: String]?
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
        super.init()
    }
    
    override func setUp() {
        super.setUp()
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
    
    func createHeaders(with additionalHeaders: [String: String]?) -> [String: String] {
        var headers = ["Content-Type": "application/json"]

        // Merge additional headers if provided
        additionalHeaders?.forEach { key, value in
            headers[key] = value
        }
        
        return headers
    }
    
    
    
    func testLoadAPIDataRequestSuccess() async {
        let expectedData = MockResponseData(message: "success")
        do {
            let result = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
            XCTAssertEqual(result.message, expectedData.message)
        } catch {
            XCTFail("Expected successful response but got error: \(error)")
        }
    }
    
    func fetchData() async throws {
        guard let url = URL(string: "\(BackendEnvironment.apiCurrency.baseURL)") else {
            throw URLError(.badURL)
        }

        do {
            let (_, _) = try await URLSession.shared.data(from: url)
            // Process data
        } catch {
            // Handle error
            print("Network request failed with error: \(error)")
            throw error // Rethrow or handle as needed
        }
    }
    
    func testLoadAPIDataRequest_Error() async {
        do {
            _ = try await fetchData()
            XCTFail("Expected an error to be thrown")
        } catch {
            // Successful if an error is caught. Optionally, verify the error type/details.
            XCTAssertEqual(error as? URLError, URLError(.notConnectedToInternet))
        }
    }
}

extension APIRequestLoader {
    func loadData(using request: URLRequest) async throws -> T.ResponseDataType? {
        let (data, response) = try await urlSession.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // Handle non-200 responses or cast failure
            throw ApplicationError.Network.General.unknown
        }
        
        return try apiRequest.parseResponse(data: data)
    }
}
