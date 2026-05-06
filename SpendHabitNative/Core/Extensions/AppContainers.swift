//
//  AppContainers.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/04/2026.
//

import Foundation
import SwiftUI

class AppContainers: Observable {    
    @State var userVM = UserViewModel()
    @State var categoryVM = CategoryViewModel()
    @State var incomeVM = IncomeViewModel()
    @State var spendingVM = SpendingViewModel()
    @State var budgetVM = BudgetViewModel()
    @State var historyVM = HistoryViewModel()
    
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
