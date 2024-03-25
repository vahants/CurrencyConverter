//
//  ConverterViewModel.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import SwiftUI

class ConverterViewModel: ObservableObject {
    
    private(set) var currencies: [Currency]? = nil
        
    @Published var model: ConverterView.Model? = nil
    @Published var amountText = ""
    
    private var isViewReady = false
    private var latestRates: LatestRates?
    private let currenciesWorker = CurrenciesWorker()
    
    private var amount: Double {
        let result = Double(amountText) ?? .zero
        return result.isNaN ? .zero : result
    }
    
    func viewIsReady() {
        Task.detached {  @MainActor [weak self] in
            guard let self = self else { return }
                        
            if !isViewReady {
                if let lastChange = try? currenciesWorker.getChange().first {
                    self.latestRates = LatestRates(rates: [lastChange.rate], modifyDate: lastChange.modifyDate, currencyCode: lastChange.from.code)
                    self.currencies = [lastChange.from, lastChange.to]
                    self.amountText = "\(lastChange.convertedAmout)"
                    
                    self.model = self.createModel(currencyFrom: lastChange.from, currencyTo: lastChange.to, rate: lastChange.rate)
                    
                    await self.getCurrencies()
                }
                isViewReady = true
            }
            
            if self.currencies == nil {
                await self.getCurrencies()
            }
        }
    }
    
    private func updateIfNeededLatestRates(from: Currency?, to: Currency?) {
        
        guard let code = from?.code, code != self.latestRates?.currencyCode else {
            return
        }
        
        Task.detached {  @MainActor [weak self] in
            guard let self = self else { return }
            let latestRates = try await self.currenciesWorker.getRates(for: code)
            guard self.model?.currencyItemFrom?.code == latestRates.currencyCode else {
                return
            }
            self.latestRates = latestRates
            let rate = latestRates.rates.first(where: { $0.code == to?.code })
            self.model = self.createModel(currencyFrom: from, currencyTo: to, rate: rate)
        }
    }
    
    private func createModel(currencyFrom: Currency?, currencyTo: Currency?, rate: Rate?) -> ConverterView.Model {
        
        let currencyItemFrom = if let currency = currencyFrom {
            ConverterView.CurrencyItem(title: "Amount", icon: "ic_flag_" + currency.code, name: currency.code, amount: "\(amount)", code: currency.code)
        } else {
            ConverterView.CurrencyItem(title: "Amount", icon: "ic_flag_default", name: "Select currency", amount: "", code: "")
        }
        
        let calculatedAmount = String(self.amount * (rate?.value ?? .zero))
        
        let currencyItemTo = if let currency = currencyTo {
            ConverterView.CurrencyItem(title: "Amount", icon: "ic_flag_" + currency.code, name: currency.code, amount: calculatedAmount, code: currency.code)
        } else {
            ConverterView.CurrencyItem(title: "Amount", icon: "ic_flag_default", name: "Select currency", amount: "", code: "")
        }
        
        let rateSubitle =  "1 " + (currencyFrom?.code ?? "") + " = " + String(rate?.value ?? 0)
        let rateTitle = "Indicative Exchange Rate"

        let model = ConverterView.Model(currencyItemFrom: currencyItemFrom, currencyItemTo: currencyItemTo, rateTitle: rateTitle, rateSubitle: rateSubitle)
        return model
    }
    
    func didSelectChangeCurrency() {
        guard
            let from = self.currencies?.first(where: { $0.code == self.model?.currencyItemFrom?.code }),
            let to = self.currencies?.first(where: { $0.code == self.model?.currencyItemTo?.code }),
            let rate = latestRates?.rates.first(where: { $0.code == to.code }) else {
            return
        }
        
        do {
            try self.currenciesWorker.save(change: from, to: to, rate: rate, convertedAmount: amount)
        } catch {
            print(error)
        }
    }
    
    func didChangeAmount(amount: String) {
        guard let model = model else {
            return
        }
        let currencyFrom = self.currencies?.first(where: { $0.code == model.currencyItemFrom?.code })
        let currencyTo = self.currencies?.first(where: { $0.code == model.currencyItemTo?.code })
        let rate = self.latestRates?.rates.first(where: { $0.code == currencyTo?.code })
        self.model = self.createModel(currencyFrom: currencyFrom, currencyTo: currencyTo, rate: rate)
    }
    
    func didSelectCurrency(currencyConvertFromTo: ConverterView.CurrencyConvertFromTo, currency: Currency) {
        
        switch currencyConvertFromTo {
        case .convertFrom:
            let to = self.currencies?.first(where: { $0.code == self.model?.currencyItemTo?.code })
            let rate = self.latestRates?.rates.first(where: { $0.code == to?.code })
            self.model = self.createModel(currencyFrom: currency, currencyTo: to, rate: rate)
            self.updateIfNeededLatestRates(from: currency, to: to)
        case .convertTo:
            let rate = self.latestRates?.rates.first(where: { $0.code == currency.code })
            let from = self.currencies?.first(where: { $0.code == self.model?.currencyItemFrom?.code })
            self.model = self.createModel(currencyFrom: from, currencyTo: currency, rate: rate)
        }
    }

    func getCurrencies () async {
        do {  
            let currencies = try await currenciesWorker.requestCurrencies()
            DispatchQueue.main.async {
                self.currencies = currencies
            }
        } catch {
            // Handle errors, possibly dispatch an error action
            // dispatch(.setError(error))
        }
    }
}
