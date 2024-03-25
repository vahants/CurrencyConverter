//
//  BackendResponseTests.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation
import XCTest
@testable import Currency_Converter

class BackendResponseTests: XCTestCase, LocalResources {
    
    struct MockData: Decodable {
        let id: Int
        let name: String
    }
    
    struct BackendResponse<T: Decodable>: Decodable {
        let status: Int?
        let message: String?
        let data: T?
    }
    
    func testBackendResponseDecoding() throws {
        let jsonData = loadJSONToData(filename: "BackendResponce")
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(BackendResponse<MockData>.self, from: jsonData)
            
            XCTAssertEqual(response.status, 200)
            XCTAssertEqual(response.message, "Success")
            XCTAssertEqual(response.data?.id, 1)
            XCTAssertEqual(response.data?.name, "Test Name")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
