//
//  CurrenciesWorker.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation

class CurrenciesWorker {
    
    private let currencieCodes = ["EUR","USD","RUB","GBP","CHF","CNY"]
    
    func requestCurrencies() async throws -> [Currency] {
        let currencies = currencieCodes.joined(separator: ",")
        do {
            let provider = CoreData.shared.provider
            let result = try await GetCurrenciesProvider.getCurrencies(currencies: currencies).currencies.compactMap({ $0.value })
            let predicate = NSPredicate(format:  "changeTo == nil AND chageFrom == nil")
            try? provider.delateAll(entityName: Currency.ManagedModel.entityName, predicate: predicate)
            try? provider.save(result)
            return result
        } catch {
            let currencieCodesSet = Set(currencieCodes)
            let results: [Currency] = try CoreData.shared.provider.fetch().filter({ currencieCodesSet.contains( $0.code ) })
            guard !results.isEmpty else {
                throw error
            }
            return results
        }
    }
    
    func getRates(for currency: String) async throws -> LatestRates {
        do {
            let currencies = currencieCodes.joined(separator: ",")
            var latest = try await GetLatestExchangeProvider.getLatest(base_currency: currency, currencies: currencies)
            latest = latest.applyed(currencyCode: currency)
            let provider = CoreData.shared.provider
            let predicate = NSPredicate(format: "currencyCode == %@", currency)
            try? provider.delateAll(entityName: LatestRates.ManagedModel.entityName, predicate: predicate)
            try? provider.save([latest])
            return latest
        } catch {
            let provider = CoreData.shared.provider
            let predicate = NSPredicate(format: "currencyCode == %@", currency)
            let results: [LatestRates] = try provider.fetch(predicate: predicate)
            guard let result = results.first else {
                throw error
            }
            return result
        }
    }
    
    func save(change from: Currency, to: Currency, rate: Rate, convertedAmount: Double) throws {
        let change = CurrencyChange(from: from, to: to, rate: rate, id: UUID().uuidString, modifyDate: Date.now, convertedAmout: convertedAmount)
        let provider = CoreData.shared.provider
        try provider.save([change])
    }
    
    func getChange(from: String? = nil, to: String? = nil) throws -> [CurrencyChange] {
        let provider = CoreData.shared.provider
        let predicate: NSPredicate? = if let from = from?.uppercased(), !from.isEmpty, let to = to?.uppercased(), !to.isEmpty {
            NSPredicate(format: "(from.code CONTAINS %@ AND to.code CONTAINS %@) OR (from.code CONTAINS %@ AND to.code CONTAINS %@)", from, to, to, from)
        } else if let from = from?.uppercased(), !from.isEmpty {
            NSPredicate(format: "from.code CONTAINS %@ OR to.code CONTAINS %@", from, from)
        } else {
            nil
        }
        let sort = CoreData.Sort(key: "modifyDate")
        return try provider.fetch(predicate: predicate, sort: [sort])
    }
}


