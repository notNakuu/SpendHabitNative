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
}

extension User {
    static let mock = User (id: 1, username: "Nakuu", email: "notnakuusemail@gmail.com", firstName: "Angel", lastName: "Mishchanchuk", registeredDate: Date.now)
}

//create a struct to update

//create a struct to create
