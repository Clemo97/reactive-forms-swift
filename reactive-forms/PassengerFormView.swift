//
//  PassengerFormView.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftUI
import SwiftData

struct PassengerFormView: View {
    @State private var viewModel: PassengerFormViewModel
    @FocusState private var focusedField: FormField?
    
    enum FormField {
        case fullName, email, username, seat
        
        var description: String {
            switch self {
            case .fullName: return "Full Name"
            case .email: return "Email"
            case .username: return "Username"
            case .seat: return "Seat"
            }
        }
    }
    
    init(passenger: Passenger, context: ModelContext) {
        _viewModel = State(initialValue: PassengerFormViewModel(passenger: passenger, context: context))
        print("🚀 [FORM] PassengerFormView initialized - reactive validation ready!")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Passenger Information")) {
                    ValidatedTextField(
                        title: "Full Name",
                        text: $viewModel.passenger.fullName,
                        result: viewModel.validationState["fullName"],
                        onSubmit: {
                            focusedField = .email
                        },
                        onChange: { _ in
                            viewModel.validateName()
                            viewModel.savePassenger()
                        }
                    )
                    .focused($focusedField, equals: .fullName)
                    
                    ValidatedTextField(
                        title: "Email",
                        text: $viewModel.passenger.email,
                        result: viewModel.validationState["email"],
                        onSubmit: {
                            focusedField = .username
                        },
                        onChange: { _ in
                            viewModel.validateEmail()
                            viewModel.savePassenger()
                        }
                    )
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    
                    ValidatedTextField(
                        title: "Username",
                        text: $viewModel.passenger.username,
                        result: viewModel.validationState["username"],
                        onSubmit: {
                            focusedField = .seat
                        },
                        onChange: { newValue in
                            viewModel.onUsernameChanged(newValue)
                            viewModel.savePassenger()
                        }
                    )
                    .focused($focusedField, equals: .username)
                    .autocapitalization(.none)
                    
                    ValidatedTextField(
                        title: "Seat",
                        text: $viewModel.passenger.seat,
                        result: viewModel.validationState["seat"],
                        onSubmit: {
                            focusedField = nil
                        },
                        onChange: { _ in
                            viewModel.validateSeat()
                            viewModel.savePassenger()
                        }
                    )
                    .focused($focusedField, equals: .seat)
                }
                
                Section {
                    Button("Complete Check-in") {
                        // All validation and saving happens automatically
                        focusedField = nil
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Check-in")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                print("👁️  [FORM] Form appeared - setting focus to Full Name field")
                focusedField = .fullName
            }
            .onChange(of: focusedField) { oldValue, newValue in
                let oldField = oldValue?.description ?? "none"
                let newField = newValue?.description ?? "none"
                print("🎯 [FOCUS] Focus changed from \(oldField) to \(newField)")
            }
        }
    }
    
    private var isFormValid: Bool {
        let states = viewModel.validationState
        return states["fullName"] == .valid &&
               states["email"] == .valid &&
               states["username"] == .valid &&
               states["seat"] == .valid
    }
}
