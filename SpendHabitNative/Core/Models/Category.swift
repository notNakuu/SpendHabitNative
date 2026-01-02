//
//  Category.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation

struct Category: Codable, Identifiable{
    let id: Int
    var iconKey: String
    var colorHex: String
    var name: String
    var isEnabled: Bool
}

struct CreateCategoryRequest: Codable {
    var name: String
    var user: IdWrapper
    var iconKey: String
    var colorHex: String
}

struct UpdateCategoryRequest: Codable {
    var name: String
    var iconKey: String
    var colorHex: String
}
