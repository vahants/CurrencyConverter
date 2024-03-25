//
//  CurrencyChange+CoreData.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import CoreData

extension CDCurrencyChange: IManagedObject {}

extension CurrencyChange: ICDConvertable {
    
    init(model: CDCurrencyChange) throws {
        guard let cdFrom = model.from,
              let cdTo = model.to,
              let cdRate = model.rate,
              let id = model.identifier,
              let date = model.modifyDate else {
            throw ApplicationError.Network.General.nonExist
        }
        let from = try Currency(model: cdFrom)
        let to = try Currency(model: cdTo)
        let rate = try Rate(model: cdRate)
        self.init(from: from, to: to, rate: rate, id: id, modifyDate: date, convertedAmout: model.convertedAmout)
    }
    
    func createManagedObject(context: NSManagedObjectContext) throws -> CDCurrencyChange {
        let result = CDCurrencyChange(context: context)
        result.modifyDate = self.modifyDate
        result.from = try self.from.createManagedObject(context: context)
        result.to = try self.to.createManagedObject(context: context)
        result.rate = try self.rate.createManagedObject(context: context)
        result.identifier = self.id
        result.convertedAmout = self.convertedAmout
        return result
    }
}
