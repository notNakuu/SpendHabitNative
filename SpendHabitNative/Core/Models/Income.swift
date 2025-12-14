//
//  Income.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import Foundation


struct Income: Codable {
    var id: Int?
    var userId: Int
    var title: String
    var methodId: Int
    var createdDate: Date
    var amount: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case methodId = "method_id"
        case createdDate
        case amount
    }
    
    
}

struct CreateIncomeRequest: Codable {
    var user: IdWrapper
    var title: String
    var method: IdWrapper
    var amount: Double
}

//create a struct to update
