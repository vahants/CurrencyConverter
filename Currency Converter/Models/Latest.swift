//
//  Latest.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct LatestRates: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case rates = "data"
    }
    
    let rates: [Rate]
    let modifyDate: Date
    let currencyCode: String?
    
    init(rates: [Rate], modifyDate: Date, currencyCode: String?) {
        self.rates = rates
        self.modifyDate = modifyDate
        self.currencyCode = currencyCode
    }
        
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let json = try container.decode([String: Double].self, forKey: .rates)
        rates = json.compactMap({ .init(code: $0.key, value: $0.value) })
        modifyDate = Date.now
        self.currencyCode = nil
    }
    
    func applyed(currencyCode: String?) -> LatestRates {
        LatestRates.init(rates: self.rates, modifyDate: self.modifyDate, currencyCode: currencyCode)
    }
}

struct Rate: Decodable {
    let code: String
    let value: Double
}
