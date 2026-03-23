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
    
    @AppStorage("lastActiveTimestamp")
    private var lastActiveTimestamp: Double = 0

    
    @State private var reloadID = UUID()
    
    @State var userVM = UserViewModel()
    @State var methodVM = MethodViewModel()
    @State var categoryVM = CategoryViewModel()
    @State var incomeVM = IncomeViewModel()
    @State var spendingVM = SpendingViewModel()
    @State var budgetVM = BudgetViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
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
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                    lastActiveTimestamp = Date().timeIntervalSince1970
            case .active:
                let now = Date().timeIntervalSince1970

                if lastActiveTimestamp != 0 {
                    let elapsed = now - lastActiveTimestamp

                    if elapsed > 15 * 60 {
                        resetApp()
                    }
                }

                lastActiveTimestamp = now

            default:
                break
            }
        }



    }
    
    private func resetApp() {
        // redo the VMs
        userVM = UserViewModel()
        //methodVM = MethodViewModel()
        categoryVM = CategoryViewModel()
        incomeVM = IncomeViewModel()
        spendingVM = SpendingViewModel()
        budgetVM = BudgetViewModel()

        // rebuild the UI
        reloadID = UUID()
    }
    
}
