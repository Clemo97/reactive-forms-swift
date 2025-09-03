//
//  Passenger.swift
//  reactive-forms
//
//  Created by Clement Lumumba on 03/09/2025.
//

import SwiftData

@Model
final class Passenger {
    var fullName: String = ""
    var email: String = ""
    var username: String = ""
    var seat: String = ""
    
    init(fullName: String = "", email: String = "", username: String = "", seat: String = "") {
        self.fullName = fullName
        self.email = email
        self.username = username
        self.seat = seat
    }
}
