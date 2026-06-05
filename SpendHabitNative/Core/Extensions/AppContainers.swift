//
//  AppContainers.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/04/2026.
//

import Foundation
import SwiftUI

@Observable
class AppContainers {
    var userVM = UserViewModel()
    var categoryVM = CategoryViewModel()
    var incomeVM = IncomeViewModel()
    var spendingVM = SpendingViewModel()
    var budgetVM = BudgetViewModel()
    var historyVM = HistoryViewModel()
    
    func resetApp() {
        // redo the VMs
        userVM = UserViewModel()
        APIToken.token = ""
        //methodVM = MethodViewModel()
        categoryVM = CategoryViewModel()
        incomeVM = IncomeViewModel()
        spendingVM = SpendingViewModel()
        budgetVM = BudgetViewModel()
        historyVM = HistoryViewModel()
    }
}
