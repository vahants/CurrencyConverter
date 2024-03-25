//
//  GetCurrenciesRequestTest.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation
import XCTest

@testable import Currency_Converter

class GetCurrenciesRequestTest: XCTestCase, LocalResources {
    
    var mockSession: URLSession!

    var loader: APIRequestLoader<GetCurrenciesRequest>!

    override func setUp() {
        super.setUp()
        let expectedURL = URL(string: GetCurrenciesProvider.Endpoint.currencies.urlString + "?" + "apikey=fca_live_28oKN8vNKTAavKao6Tsj2x2onAkWq6lWYlQsYDL0")!
        let data = loadJSONToData(filename: "Currencies")
        mockSession = URLSession.sessionConfigurationMocked(
            url: expectedURL,
            data: data
        )

        let request = GetCurrenciesRequest()
        loader = APIRequestLoader(apiRequest: request, urlSession: mockSession)
    }

    func testGetCurrenciesSuccess() async {
        let decoder = JSONDecoder()
        do {
            let currencies = loadJSONToData(filename: "Currencies")
            let currenciesJSON = try decoder.decode(CurrencyResponse.self, from: currencies)
            
            let result = try await loader.loadAPIDataRequest(requestData: nil, type: .get)
            XCTAssertEqual(currenciesJSON.currencies.first?.value.code, result.currencies.first?.value.code)
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
