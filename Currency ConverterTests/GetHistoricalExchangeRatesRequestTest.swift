//
//  GetHistoricalExchangeRatesRequestTest.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import XCTest

@testable import Currency_Converter

class GetHistoricalExchangeRatesRequestTest: XCTestCase, LocalResources {
    
    var mockSession: URLSession!

    var loader: APIRequestLoader<GetHistoricalExchangeRatesRequest>!

    override func setUp() {
        super.setUp()
        let expectedURL = URL(string: GetHistoricalExchangeRatesProvider.Endpoint.historical.urlString + "?" + "apikey=fca_live_28oKN8vNKTAavKao6Tsj2x2onAkWq6lWYlQsYDL0")!
        let data = loadJSONToData(filename: "Historical")
        mockSession = URLSession.sessionConfigurationMocked(
            url: expectedURL,
            data: data
        )

        let request = GetHistoricalExchangeRatesRequest()
        loader = APIRequestLoader(apiRequest: request, urlSession: mockSession)
    }

    func testGetCurrenciesSuccess() async {
        let decoder = JSONDecoder()
        do {
            let latest = loadJSONToData(filename: "Historical")
            let latestJSON = try decoder.decode(HistoricalCurrencyRates.self, from: latest)
            
            let result = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
            XCTAssertEqual(latestJSON.data.keys.first, result.data.keys.first)
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
