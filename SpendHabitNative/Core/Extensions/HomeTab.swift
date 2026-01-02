//
//  HomeTab.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 26/12/25.
//

import Foundation

enum HomeTab: Int, CaseIterable {
    case incomes
    case spendings
    case budgets

    var title: String {
        switch self {
        case .incomes: return "Incomes"
        case .spendings: return "Spendings"
        case .budgets: return "Budgets"
        }
    }
}
