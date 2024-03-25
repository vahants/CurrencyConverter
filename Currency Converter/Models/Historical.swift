//
//  Historical.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct HistoricalCurrencyRates: Decodable {
    let data: [String: [String: Double]]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

extension HistoricalCurrencyRates {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([String: [String: Double]].self, forKey: .data)
    }
}
