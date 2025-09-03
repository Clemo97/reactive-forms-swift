# Reactive SwiftUI Forms Demo

This project demonstrates a reactive SwiftUI form implementation following the article "Reactive SwiftUI Forms with SwiftData, Validation & Combine" by Wesley Matlock.

## Features

- ✅ **Live Validation**: Forms validate in real-time as users type
- ✅ **Async Username Checking**: Username availability check with debounced input
- ✅ **Auto-Save**: Form data automatically saves to SwiftData as fields are edited
- ✅ **Visual Feedback**: Dynamic border colors and error messages
- ✅ **Smooth UX**: Focus management and keyboard flow between fields
- ✅ **Combine Integration**: Reactive programming with Combine framework

## Architecture

### Core Components

1. **Passenger.swift** - SwiftData model for passenger information
2. **ValidationResult.swift** - Validation state enum and form validator utilities
3. **PassengerFormViewModel.swift** - Observable view model with Combine pipelines
4. **ValidatedTextField.swift** - Reusable text field component with validation display
5. **ValidationStyle.swift** - Custom ViewModifier for validation styling
6. **PassengerFormView.swift** - Main form view with focus management
7. **ContentView.swift** - Entry point showing form and saved passengers

### Key Technologies

- **SwiftUI** - Declarative UI framework
- **SwiftData** - Data persistence layer
- **Combine** - Reactive programming for async validation
- **@Observable** - Modern observation system for ViewModels

## How It Works

### Real-Time Validation

The form validates fields as users interact with them:

```swift
ValidatedTextField(
    title: "Email", 
    text: $viewModel.passenger.email,
    result: viewModel.validationState["email"],
    onChange: { _ in
        viewModel.validateEmail()
        viewModel.savePassenger()
    }
)
```

### Async Username Validation

Username checking uses Combine to debounce input and simulate an API call:

```swift
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
```

### Auto-Save with SwiftData

Every field change triggers both validation and saving:

```swift
onChange: { _ in
    viewModel.validateEmail()
    viewModel.savePassenger() // Auto-saves to SwiftData
}
```

## Running the Project

1. Open `reactive-forms.xcodeproj` in Xcode
2. Select iPhone simulator (iOS 18.5+)
3. Press `⌘+R` to build and run
4. Tap "Start Check-in" to open the reactive form

## Try These Features

1. **Email Validation** - Type an invalid email to see real-time feedback
2. **Username Checking** - Try usernames like "james", "lars", "kirk", or "robert" to see "taken" status
3. **Required Fields** - Leave fields empty to see validation errors
4. **Auto-Save** - Fill out the form, close it, and reopen to see saved data
5. **Focus Flow** - Use Return key to move between fields

## Easter Egg

The username validator includes a nod to Metallica's 1986 "Master of Puppets" tour. Try entering band member names to trigger the "Username taken at Gate M72" message! 🎸

## Credits

Based on the excellent article by [Wesley Matlock](https://medium.com/@wesleymatlock/reactive-swiftui-forms-with-swiftdata-validation-combine-4cbd5ccf9ca9).

## Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 5.9+
