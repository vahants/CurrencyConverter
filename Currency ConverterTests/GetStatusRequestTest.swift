//
//  GetStatusRequestTest.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import XCTest

@testable import Currency_Converter

class GetStatusRequestTest: XCTestCase, LocalResources {
    
    var mockSession: URLSession!

    var loader: APIRequestLoader<GetStatusRequest>!

    override func setUp() {
        super.setUp()
        let expectedURL = URL(string: GetStatusProvider.Endpoint.status.urlString + "?" + "apikey=fca_live_28oKN8vNKTAavKao6Tsj2x2onAkWq6lWYlQsYDL0")!
        let data = loadJSONToData(filename: "Quotas")
        mockSession = URLSession.sessionConfigurationMocked(
            url: expectedURL,
            data: data
        )

        let request = GetStatusRequest()
        loader = APIRequestLoader(apiRequest: request, urlSession: mockSession)
    }

    func testGetCurrenciesSuccess() async {
        let decoder = JSONDecoder()
        do {
            let quotas = loadJSONToData(filename: "Quotas")
            let quotasJSON = try decoder.decode(QuotasResponse.self, from: quotas)
            
            let result = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
            XCTAssertEqual(quotasJSON.quotas.month.remaining, result.quotas.month.remaining)
            XCTAssertEqual(quotasJSON.quotas.month.total, result.quotas.month.total)
            XCTAssertEqual(quotasJSON.quotas.month.used, result.quotas.month.used)
        } catch {
            XCTFail("Expected success but received error: \(error)")
        }
    }

    override func tearDown() {
        URLProtocolMock.mockResponses.removeAll()
        mockSession = nil
        super.tearDown()
    }
}
