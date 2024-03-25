//
//  Currency.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct CurrencyResponse: Decodable {
    let currencies: [String: Currency]

    enum CodingKeys: String, CodingKey {
        case currencies = "data"
    }
}

struct Currency: Decodable {
    
    let symbol: String?
    let name: String
    let symbolNative: String?
    let decimalDigits: Int?
    let rounding: Int?
    let code: String
    let namePlural: String?

    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding
        case code
        case namePlural = "name_plural"
    }
}

extension CurrencyResponse {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currencies = try container.decode([String: Currency].self, forKey: .currencies)
    }
    
}
