//
//  reactive_formsApp.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftUI
import SwiftData

@main
struct reactive_formsApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Passenger.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
