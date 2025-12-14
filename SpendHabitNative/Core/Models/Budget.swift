//
//  Budget.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import Foundation


struct Budget: Codable, Identifiable{
    var id: Int?
    var categoryId: Int
    var createdDate: Date
    var amount: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case createdDate
        case amount
    }
}

struct UpdateBudgetRequest: Codable {
    var id: Int
    var user: IdWrapper
    var category: IdWrapper
    var amount: Double
}

extension Budget {
    static let mock = Budget (id: 1, categoryId: 15, createdDate: Date(), amount: 150)
}
