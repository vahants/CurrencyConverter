//
//  CurrencyChange.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

struct CurrencyChange {
    
    let from: Currency
    let to: Currency
    let rate: Rate
    let id: String
    let modifyDate: Date
    let convertedAmout: Double
}


