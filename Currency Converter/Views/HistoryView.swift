//
//  HistoryView.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()
    
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.models) { model in
                    ConversionCell(date: model.date, title: model.title, subtitle: model.subtitle)
                }
            }
            .navigationTitle("Conversion History")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search by currency")
            .onSubmit(of: .search) {
                // Perform the search
            }
            .onChange(of: searchText) { newValue in
                viewModel.getHistory(searchText: newValue)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.getHistory(searchText: searchText)
        }
    }
}

struct ConversionCell: View {
    var date: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack {
            
            HStack {
                Text(date)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                Text(title)
                    .font(.body)
                Spacer()
            }
            HStack {
                Text(subtitle)
                    .font(.callout)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

extension HistoryView {
    
    struct HistoryItem: Identifiable {
        let date: String
        let title: String
        let subtitle: String
        let id: String
    }
}
