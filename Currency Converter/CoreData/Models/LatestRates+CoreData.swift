//
//  LatestRates+CoreData.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import CoreData

extension CDLatestRates: IManagedObject {}

extension LatestRates: ICDConvertable {
    
    init(model: CDLatestRates) throws {
        guard let cdRates = model.rates as? Set<CDRate>, let date = model.modifyDate else {
            throw ApplicationError.Network.General.nonExist
        }
        let rates = try cdRates.compactMap({ try Rate(model: $0) })
        self.init(rates: rates, modifyDate: date, currencyCode: model.currencyCode)
    }
    
    func createManagedObject(context: NSManagedObjectContext) throws -> CDLatestRates {
        let result = CDLatestRates(context: context)
        result.modifyDate = modifyDate
        result.currencyCode = currencyCode
        result.rates = .init()
        
        try self.rates.forEach { rate in
            try result.addToRates(rate.createManagedObject(context: context))
        }
        return result
    }
}

extension CDRate: IManagedObject {}

extension Rate: ICDConvertable {
    
    init(model: CDRate) throws {
        guard let code = model.code else {
            throw ApplicationError.Network.General.nonExist
        }
        self.init(code: code, value: model.value)
    }
    
    func createManagedObject(context: NSManagedObjectContext) throws -> CDRate {
        let result = CDRate(context: context)
        result.code = self.code
        result.value = self.value
        return result
    }
}
