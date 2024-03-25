//
//  BackendEnvironment.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

/// Application environment
public enum BackendEnvironment: String, CaseIterable {

    case production = "Production"
    case test = "Test"

    static var apiCurrency = CEnvironmentInfo(
        identifier: "API",
        testSubPath: "api.",
        customBranchFactory: { "https://\($0).freecurrencyapi.com" }
    )
    
    static var allEnvironments: [CEnvironmentInfo] = [
        Self.apiCurrency
    ]
}

class CEnvironmentInfo {

    private(set) var current: BackendEnvironment = .test

    var customEnvironment: String!

    let identifier: StaticString

    let testSubPath: String
    let prodSubPath: String
    let customBranchFactory: (String) -> String

    var domain: String {
        switch current {
        case .production:
            return "freecurrencyapi.com"
        case .test:
            return "freecurrencyapi.com" // testURL "staging.freecurrencyapi.com"
        }
    }

    init(
        identifier: StaticString,
        testSubPath: String = "",
        prodSubPath: String = "",
        customBranchFactory: @escaping (String) -> String
    ) {
        self.identifier = identifier
        self.testSubPath = testSubPath
        self.prodSubPath = prodSubPath
        self.customBranchFactory = customBranchFactory
    }

    var baseURL: String {
        switch current {
        case .production:
            return "\(networkProtocol)://\(prodSubPath)\(domain)"
        case .test:
            return "\(networkProtocol)://\(testSubPath)\(domain)"
        }
    }

    private var networkProtocol: String {
        return "HTTPS"
    }
}
