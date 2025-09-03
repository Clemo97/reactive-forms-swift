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
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .flatMap { username in
                self.validationState["username"] = .checking
                return self.checkUsernameAvailability(username)
            }
            .sink { result in
                self.validationState["username"] = result
            }
            .store(in: &cancellables)
    }

    private func checkUsernameAvailability(_ username: String) -> AnyPublisher<ValidationResult, Never> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let takenNames = ["james", "lars", "kirk", "robert"]
                if takenNames.contains(username.lowercased()) {
                    promise(.success(.invalid("Username taken at Gate M72")))
                } else {
                    promise(.success(.valid))
                }
            }
        }.eraseToAnyPublisher()
    }

    func onUsernameChanged(_ newUsername: String) {
        usernameSubject.send(newUsername)
    }
    
    func validateEmail() {
        validationState["email"] = FormValidator.validateEmail(passenger.email)
    }

    func validateName() {
        validationState["fullName"] = FormValidator.validateRequired(passenger.fullName, fieldName: "Full Name")
    }
    
    func validateSeat() {
        validationState["seat"] = FormValidator.validateRequired(passenger.seat, fieldName: "Seat")
    }
    
    func savePassenger() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save passenger: \(error)")
        }
    }
}
