//
//  ViewHelper.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 24.03.24.
//

import Foundation
import SwiftUI
import Combine

struct RoundButtonWithImage: View {
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        Button(action: action) {
            Image(imageName, bundle: Bundle.main)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .padding(10)
        }
        .foregroundColor(.white)
        .clipShape(Circle())
    }
}

struct NumberTextField: View {
    @Binding var number: String
    var name: String
    
    private let numberRegex = #"\b\d+(\.\d+)?\b"#
    
    var body: some View {
        TextField(name, text: $number)
            .onChange(of: number) { newValue in
                if !newValue.isEmpty && !NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: newValue) {
                    
                    let components = newValue.components(separatedBy: ".")
                    if components.count > 2 || (components.count == 2 && components[1].count > 1) {
                        // More than one decimal point or more than one digit after decimal
                        self.number = String(newValue.dropLast())
                    } else {
                        // Allow the change
                        self.number = newValue
                    }
                    
                    self.number = self.number.filter { "0123456789.".contains($0) }
                }
            }
    }
}
