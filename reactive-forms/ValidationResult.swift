//
//  ValidationResult.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import Foundation

enum ValidationResult: Equatable {
    case valid
    case invalid(String)
    case checking
}

struct FormValidator {
    static func validateEmail(_ email: String) -> ValidationResult {
        guard email.contains("@") else {
            return .invalid("Email must contain @")
        }
        return .valid
    }

    static func validateRequired(_ value: String, fieldName: String) -> ValidationResult {
        value.trimmingCharacters(in: .whitespaces).isEmpty ? .invalid("\(fieldName) is required") : .valid
    }
}
