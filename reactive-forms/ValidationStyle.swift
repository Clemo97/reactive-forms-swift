//
//  ValidationStyle.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftUI

struct ValidationStyle: ViewModifier {
    let result: ValidationResult?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(strokeColor, lineWidth: 1)
            )
            .animation(.easeInOut, value: result)
    }
    
    private var strokeColor: Color {
        switch result {
        case .valid:
            return .green
        case .invalid(_):
            return .red
        case .checking:
            return .blue
        case .none:
            return .clear
        }
    }
}
