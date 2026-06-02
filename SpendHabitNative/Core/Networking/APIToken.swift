//
//  APIToken.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/2/26.
//

import Foundation

class APIToken {
    static var token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJOYWt1dSIsInVzZXJJZCI6MSwiaWF0IjoxNzcxMzQyODg0LCJleHAiOjE4MDI4Nzg4ODR9.KTPBEsyO6xYxhY_IsX1lPZYsV3B5HE4WtfV8QtH5AbI"
    static var expiresAt: Date?

    static var isValid: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() < expiresAt
    }
}
