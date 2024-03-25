//
//  Quota.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct QuotasResponse: Decodable {
    let quotas: Quotas
    
    enum CodingKeys: String, CodingKey {
        case quotas
    }
}

struct Quotas: Decodable {
    let month: Quota
    
    enum CodingKeys: String, CodingKey {
        case month
    }
}

struct Quota: Decodable {
    let total: Int
    let used: Int
    let remaining: Int
    
    enum CodingKeys: String, CodingKey {
        case total, used, remaining
    }
}

extension QuotasResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quotas = try container.decode(Quotas.self, forKey: .quotas)
    }
}

extension Quotas {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        month = try container.decode(Quota.self, forKey: .month)
    }
}
