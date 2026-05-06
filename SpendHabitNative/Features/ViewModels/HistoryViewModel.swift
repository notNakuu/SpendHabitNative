//
//  PastMonthViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 01/05/2026.
//

import Foundation

@MainActor
@Observable
class HistoryViewModel {
    var spendings: [Spending] = []
    var incomes: [Income] = []
    var budgets: [Budget] = []
    
    var totalSpending: Double {
        Double(spendings.reduce(0) { $0 + $1.amount })
    }
    
    var totalIncome: Double {
        Double(incomes.reduce(0) { $0 + $1.amount })
    }
    
    var totalBudget: Double {
        Double(budgets.reduce(0) { $0 + $1.amount })
    }
    
    
}
