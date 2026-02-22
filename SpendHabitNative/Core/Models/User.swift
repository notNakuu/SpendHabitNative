//
//  User.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

struct User: Codable{
    let id: Int
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    let registeredDate: Date
    
    var monthsRegistered: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month],
            from: registeredDate,
            to: Date()
        )

        let years = components.year ?? 0
        let months = components.month ?? 0

        return max(years * 12 + months, 0)
    }

}


extension User {
    static let mock = User (id: 1, username: "Nakuu", email: "notnakuusemail@gmail.com", firstName: "Angel Mariano", lastName: "Mishchanchuk Dovzhytska", registeredDate: Date.now)
}

//create a struct to update

//create a struct to create
struct UserCreate: Codable{
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var password: String
}

struct UserLogin: Codable{
    var username: String
    var password: String
}
