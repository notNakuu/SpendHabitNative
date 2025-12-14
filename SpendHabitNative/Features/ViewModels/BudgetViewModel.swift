//
//  BugetViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import Foundation

@Observable
class BudgetViewModel {
    var newBudget: CreateBudgetRequest?
    var budgets: [Budget] = []
    var network = NetworkService()
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var resultCode: Int? = nil
    
    
    
    
    
}
