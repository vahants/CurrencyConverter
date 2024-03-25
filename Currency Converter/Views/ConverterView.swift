//
//  ConverterView.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import SwiftUI
import Combine


struct ConverterView: View {
    
    @StateObject var viewModel = ConverterViewModel()
    @State private var showActionSheet = false
    @State private var currencyConvertFromTo: CurrencyConvertFromTo = .convertFrom
    @FocusState private var isTextFieldFocused: Bool

    enum CurrencyConvertFromTo {
        case convertFrom
        case convertTo
    }

    let selectedFromIndex: Int = 0
    let selectedToIndex: Int = 0

    var body: some View {
        
        VStack (alignment: .leading, spacing: 10) {
            Form {
                Section(header: Text("Currency Converter")) {
                    HStack {
                        RoundButtonWithImage(action: {
                            self.currencyConvertFromTo = .convertFrom
                            self.showActionSheet = true
                            
                        }, imageName: viewModel.model?.currencyItemFrom?.icon ?? "ic_flag_default")
                        
                        Text(viewModel.model?.currencyItemFrom?.name ?? "Select Currency")
                        Spacer()
                        
                        NumberTextField(number: $viewModel.amountText, name: "Amount")
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: viewModel.amountText) { newValue in
                                viewModel.didChangeAmount(amount: newValue)
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        isTextFieldFocused = false
                                    }
                                }
                            }
                            .focused($isTextFieldFocused)

                    }
                    
                    HStack {
                        RoundButtonWithImage(action: {
                            self.currencyConvertFromTo = .convertTo
                            self.showActionSheet = true
                        }, imageName: viewModel.model?.currencyItemTo?.icon ?? "ic_flag_default")
                        Text(viewModel.model?.currencyItemTo?.name ?? "Select Currency")
                        Spacer()
                        Text(viewModel.model?.currencyItemTo?.amount ?? "")
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .frame(height: 200)
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Select an option"), message: nil, buttons: actionSheetButtons(currencyConvertFromTo: currencyConvertFromTo))
            }
            
            GeometryReader { geometry in
                
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        viewModel.didSelectChangeCurrency()
                    }) {
                        Text("Change")
                            .padding()
                            .frame(width: 120, height: 30)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(EdgeInsets(top: 0, leading: geometry.size.width/2 - 60, bottom: 0, trailing: 0))
                    
                    Text(viewModel.model?.rateTitle ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 10, leading:20, bottom: 0, trailing: 0))
                    
                    Text(viewModel.model?.rateSubitle ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 0, leading:20, bottom: 0, trailing: 0))
                }
                Spacer()
            }

        }

        .onAppear {
            viewModel.viewIsReady()
        }
    }

    func actionSheetButtons(currencyConvertFromTo: CurrencyConvertFromTo) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for currency in viewModel.currencies ?? [] {
            buttons.append(.default(Text(currency.name)) {
                // Action to perform when an option is selected
                viewModel.didSelectCurrency(currencyConvertFromTo: currencyConvertFromTo, currency: currency)
            })
        }
        
        buttons.append(.cancel())
        
        return buttons
    }
}

extension ConverterView {
    
    struct CurrencyItem {
        let title: String
        let icon: String
        let name: String
        let amount: String
        let code: String
    }
    
    struct Model {
        let currencyItemFrom:  CurrencyItem?
        let currencyItemTo:  CurrencyItem?
        
        let rateTitle: String?
        let rateSubitle: String?
    }
}
