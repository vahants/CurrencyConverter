//
//  HistoryViewModel.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 25.03.24.
//

import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    
    private let currenciesWorker = CurrenciesWorker()
    
    @Published var models: [HistoryView.HistoryItem] = []

    
    func getHistory(searchText: String?) {

        let texts = searchText?.components(separatedBy: " ")
        
        do {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            
            let first = texts?.first
            let last = (texts?.count ?? .zero > 1) ? texts?.last : nil
            
            let history = try currenciesWorker.getChange(from: first, to: last)
            models = history.compactMap({
                let title = "1 \($0.from.code) = \($0.rate.value) \($0.to.code)"
                let subtitle = "\($0.convertedAmout) \($0.from.code) = \($0.rate.value * $0.convertedAmout) \($0.to.code)"
                let date = formatter.string(from: $0.modifyDate)
                return .init(date: date, title: title, subtitle: subtitle, id: $0.id)
            })
            
        } catch {
            models = []
        }
    }
}
