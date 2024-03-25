//
//  Currency+CodeData.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import CoreData

extension CDCurrency: IManagedObject {}

extension Currency: ICDConvertable {
        
    init(model: CDCurrency) throws {
        guard let name = model.name, let code = model.code else {
            throw ApplicationError.CoreDataError.dataNotExist
        }
        self.init(symbol: model.symbol, name: name, symbolNative: model.symbolNative, decimalDigits: Int(model.decimalDigits), rounding: Int(model.rounding), code: code, namePlural: model.namePlural)
    }
    
    func createManagedObject(context: NSManagedObjectContext) throws -> CDCurrency {
        let result = CDCurrency(context: context)
        result.code = self.code
        result.symbol = self.symbol
        result.name = self.name
        result.symbolNative = self.symbolNative
        result.decimalDigits = Int32(self.decimalDigits ?? .zero)
        result.rounding = Int32(self.rounding ?? .zero)
        result.namePlural = self.namePlural
        return result
    }
}
