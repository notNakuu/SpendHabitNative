//
//  ResponseModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

struct ResponseModel<T: Decodable>: Decodable {
    let success: Int
    let message: String
    let data: T?
}

struct LoginResponse: Codable {
    let token: String
    let user: User
}


