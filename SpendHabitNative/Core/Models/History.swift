//
//  History.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 01/05/2026.
//

import Foundation

struct History: Codable {
    let spendings: [Spending]
    let incomes: [Income]
    let budgets: [Budget]
}
