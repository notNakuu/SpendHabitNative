//
//  APIToken.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/2/26.
//

import Foundation

class APIToken {
    static var token = ""
    static var expiresAt: Date?

    static var isValid: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() < expiresAt
    }
}
