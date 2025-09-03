//
//  PassengerFormViewModel.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import Combine
import Observation
import SwiftData
import Foundation

@Observable
final class PassengerFormViewModel {
    var passenger: Passenger
    
    var validationState: [String: ValidationResult] = [:]
    @ObservationIgnored
    var modelContext: ModelContext
    
    private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored
    private let usernameSubject = PassthroughSubject<String, Never>()

    init(passenger: Passenger, context: ModelContext) {
        self.passenger = passenger
        self.modelContext = context
        observeUsername()
    }
    
    private func observeUsername() {
        usernameSubject
            .removeDuplicates()
            .handleEvents(receiveOutput: { username in
                print("🔄 [DEBOUNCE] Username input received: '\(username)'")
            })
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .handleEvents(receiveOutput: { username in
                print("⏰ [DEBOUNCE] Debounce completed for: '\(username)' (400ms passed)")
            })
            .flatMap { username in
                print("🔍 [VALIDATION] Starting async username check for: '\(username)'")
                self.validationState["username"] = .checking
                return self.checkUsernameAvailability(username)
            }
            .sink { result in
                print("✅ [VALIDATION] Username validation completed: \(result)")
                self.validationState["username"] = result
            }
            .store(in: &cancellables)
    }

    private func checkUsernameAvailability(_ username: String) -> AnyPublisher<ValidationResult, Never> {
        print("🌐 [API SIMULATION] Simulating API call for username: '\(username)'")
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let takenNames = ["james", "lars", "kirk", "robert"]
                if takenNames.contains(username.lowercased()) {
                    print("❌ [API SIMULATION] Username '\(username)' is TAKEN")
                    promise(.success(.invalid("Username taken at Gate M72")))
                } else {
                    print("✅ [API SIMULATION] Username '\(username)' is AVAILABLE")
                    promise(.success(.valid))
                }
            }
        }.eraseToAnyPublisher()
    }

    func onUsernameChanged(_ newUsername: String) {
        print("⌨️  [INPUT] Username changed to: '\(newUsername)'")
        usernameSubject.send(newUsername)
    }
    
    func validateEmail() {
        print("📧 [VALIDATION] Validating email: '\(passenger.email)'")
        let result = FormValidator.validateEmail(passenger.email)
        print("📧 [VALIDATION] Email validation result: \(result)")
        validationState["email"] = result
    }

    func validateName() {
        print("👤 [VALIDATION] Validating full name: '\(passenger.fullName)'")
        let result = FormValidator.validateRequired(passenger.fullName, fieldName: "Full Name")
        print("👤 [VALIDATION] Full name validation result: \(result)")
        validationState["fullName"] = result
    }
    
    func validateSeat() {
        print("💺 [VALIDATION] Validating seat: '\(passenger.seat)'")
        let result = FormValidator.validateRequired(passenger.seat, fieldName: "Seat")
        print("💺 [VALIDATION] Seat validation result: \(result)")
        validationState["seat"] = result
    }
    
    func savePassenger() {
        print("💾 [SAVE] Attempting to save passenger data...")
        do {
            try modelContext.save()
            print("💾 [SAVE] ✅ Passenger data saved successfully")
        } catch {
            print("💾 [SAVE] ❌ Failed to save passenger: \(error)")
        }
    }
}
