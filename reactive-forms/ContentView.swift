//
//  ContentView.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var passengers: [Passenger]
    @State private var showingForm = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "airplane")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.system(size: 50))
                
                Text("Reactive Forms Demo")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("SwiftUI + SwiftData + Combine")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button("Start Check-in") {
                    let newPassenger = Passenger()
                    modelContext.insert(newPassenger)
                    showingForm = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                if !passengers.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Passengers:")
                            .font(.headline)
                        
                        ForEach(passengers) { passenger in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(passenger.fullName.isEmpty ? "Unnamed" : passenger.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                if !passenger.email.isEmpty {
                                    Text(passenger.email)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Airline Check-in")
        }
        .sheet(isPresented: $showingForm) {
            if let lastPassenger = passengers.last {
                PassengerFormView(passenger: lastPassenger, context: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Passenger.self, inMemory: true)
}
