//
//  Spending.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation

struct Spending: Codable, Identifiable {
    let id: Int?
    let userId: Int
    var title: String
    var categoryId: Int
    var methodId: Int
    let createdDate: Date
    var amount: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case categoryId = "category_id"
        case methodId = "method_id"
        case createdDate
        case amount
    }
}

struct CreateSpendingRequest: Codable {
    var user: IdWrapper
    var title: String
    var category: IdWrapper
    var method: IdWrapper
    var amount: Double
}

//create a struct to update

struct IdWrapper: Codable {
    var id: Int
}


