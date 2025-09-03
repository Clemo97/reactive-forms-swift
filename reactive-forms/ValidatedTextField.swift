//
//  ValidatedTextField.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftUI

struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    let result: ValidationResult?
    let onSubmit: () -> Void
    var onChange: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
                .modifier(ValidationStyle(result: result))
                .onSubmit(onSubmit)
                .onChange(of: text) { oldValue, newValue in
                    if oldValue != newValue {
                        print("🎯 [TEXTFIELD] '\(title)' changed from '\(oldValue)' to '\(newValue)'")
                    }
                    onChange?(newValue)
                }
            
            if case .invalid(let message) = result {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
            } else if result == .checking {
                HStack {
                    ProgressView()
                        .scaleEffect(0.5)
                    Text("Checking...")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}
