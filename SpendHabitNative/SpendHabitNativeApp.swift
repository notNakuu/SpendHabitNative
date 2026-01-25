//
//  SpendHabitNativeApp.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import SwiftUI

@main
struct SpendHabitNativeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var reloadID = UUID()
    @State private var lastBackgroundDate: Date?
    
    @State var userVM = UserViewModel()
    @State var methodVM = MethodViewModel()
    @State var categoryVM = CategoryViewModel()
    @State var incomeVM = IncomeViewModel()
    @State var spendingVM = SpendingViewModel()
    @State var budgetVM = BudgetViewModel()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .id(reloadID)
                .environment(methodVM)
                .environment(userVM)
                .environment(categoryVM)
                .environment(incomeVM)
                .environment(spendingVM)
                .environment(budgetVM)
                .task {
                    await methodVM.loadMethods()
                }
        }
        .onChange(of: scenePhase){ _, newPhase in
            switch newPhase{
            case .background:
                lastBackgroundDate = Date()
            case .active:
                if let last = lastBackgroundDate {
                    let elapsed = Date().timeIntervalSince(last)
                    if elapsed > 15 * 60 {
                        resetApp()
                    }
                }
            default:
                break
            }
        
        }
    }
    
    private func resetApp() {
        // redo the VMs
        userVM = UserViewModel()
        methodVM = MethodViewModel()
        categoryVM = CategoryViewModel()
        incomeVM = IncomeViewModel()
        spendingVM = SpendingViewModel()
        budgetVM = BudgetViewModel()

        // rebuild the UI
        reloadID = UUID()
    }
    
}
