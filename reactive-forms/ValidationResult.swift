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

// MARK: - CustomStringConvertible for better console output
extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .valid:
            return "✅ VALID"
        case .invalid(let message):
            return "❌ INVALID: \(message)"
        case .checking:
            return "⏳ CHECKING..."
        }
    }
}

struct FormValidator {
    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        if trimmedEmail.isEmpty {
            return .invalid("Email is required")
        }
        
        guard trimmedEmail.contains("@") else {
            return .invalid("Email must contain @")
        }
        
        // Basic email format check
        let emailParts = trimmedEmail.split(separator: "@")
        guard emailParts.count == 2, 
              !emailParts[0].isEmpty, 
              !emailParts[1].isEmpty else {
            return .invalid("Invalid email format")
        }
        
        return .valid
    }

    static func validateRequired(_ value: String, fieldName: String) -> ValidationResult {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        return trimmedValue.isEmpty ? .invalid("\(fieldName) is required") : .valid
    }
}
