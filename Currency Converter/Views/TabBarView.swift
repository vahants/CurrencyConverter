//
//  TabBarView.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import SwiftUI

enum TabItems : Int, CaseIterable {
    case exchange
    case history
}

struct TabBarView: View {

    var body: some View {
        VStack(spacing: 0) {
            // Content
            tabView
        }
    }
        
    private var tabView: some View {
        TabView() {
            ConverterView()
                .tabItem {
                    Image("ic_converter", bundle: .main)
                    Text("Converter")
                }

            HistoryView()
                .tabItem {
                    Image("ic_history", bundle: .main)
                    Text("History")
                }
        }
    }
}

