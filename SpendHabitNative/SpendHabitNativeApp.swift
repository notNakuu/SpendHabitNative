//
//  SpendHabitNativeApp.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import SwiftUI

@main
struct SpendHabitNativeApp: App {
    @State var methodVM = MethodViewModel()
    @State var categoryVM = CategoryViewModel()
    @State var incomeVM = IncomeViewModel()
    @State var spendingVM = SpendingViewModel()
    @State var budgetVM = BudgetViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(methodVM)
                .environment(categoryVM)
                .environment(incomeVM)
                .environment(spendingVM)
                .environment(budgetVM)
                .task {
                    await methodVM.loadMethods()
                }
        }
    }
}
