//
//  GetLatestExchangeRequestTest.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import XCTest

@testable import Currency_Converter

class GetLatestExchangeRequestTest: XCTestCase, LocalResources {
    
    var mockSession: URLSession!

    var loader: APIRequestLoader<GetLatestExchangeRequest>!

    override func setUp() {
        super.setUp()
        let expectedURL = URL(string: GetLatestExchangeProvider.Endpoint.latest.urlString + "?" + "apikey=fca_live_28oKN8vNKTAavKao6Tsj2x2onAkWq6lWYlQsYDL0")!
        let data = loadJSONToData(filename: "Latest")
        mockSession = URLSession.sessionConfigurationMocked(
            url: expectedURL,
            data: data
        )

        let request = GetLatestExchangeRequest()
        loader = APIRequestLoader(apiRequest: request, urlSession: mockSession)
    }

    func testGetCurrenciesSuccess() async {
        let decoder = JSONDecoder()
        do {
            let latest = loadJSONToData(filename: "Latest")
            let latestJSON = try decoder.decode(LatestRates.self, from: latest)
            
            let result = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
            XCTAssertEqual(latestJSON.rates.first?.code, result.rates.first?.code)
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
