//
//  User.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

struct User: Codable{
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let registeredDate: Date
    
    var monthsRegistered: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.month],
            from: registeredDate,
            to: Date()
        )

        // At least 1 month to avoid division by zero
        return max(components.month ?? 0, 1)
    }
}

extension User {
    static let mock = User (id: 1, username: "Nakuu", email: "notnakuusemail@gmail.com", firstName: "Angel", lastName: "Mishchanchuk", registeredDate: Date.now)
}

//create a struct to update

//create a struct to create
