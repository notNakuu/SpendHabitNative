//
//  PreviewContainer.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import Foundation


import SwiftUI

struct PreviewContainer<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Mock VMs
    private let methodVM: MethodViewModel = {
        let vm = MethodViewModel()
        vm.methods = [
            Method(id: 2, iconKey: "creditcard.fill", name: "Card"),
            Method(id: 1, iconKey: "banknote.fill", name: "Cash"),
            Method(id: 3, iconKey: "phone.fill", name: "Bizum"),
            Method(id: 4, iconKey: "building.columns.fill", name: "Transfer")
        ]
        return vm }()

    private let containers: AppContainers = {
        let c = AppContainers()
        
        // User
        c.userVM.user = User.mock
        
        // Categories
        c.categoryVM.categories = [
            Category(id: 15, iconKey: "cart.fill", colorHex: "#FF5733", name: "Food", isEnabled: true),
            Category(id: 16, iconKey: "house.fill", colorHex: "#33FF57", name: "Home", isEnabled: true),
            Category(id: 17, iconKey: "car.fill", colorHex: "#3357FF", name: "Transport", isEnabled: true),
            Category(id: 18, iconKey: "heart.fill", colorHex: "#FF33A1", name: "Health", isEnabled: true),
            Category(id: 19, iconKey: "bag.fill", colorHex: "#FFC300", name: "Shopping", isEnabled: true),
            Category(id: 20, iconKey: "creditcard.fill", colorHex: "#DAF7A6", name: "Bills", isEnabled: true),
            Category(id: 21, iconKey: "gift.fill", colorHex: "#FF5733", name: "Entertainment", isEnabled: true)
        ]
        
        // Income
        c.incomeVM.incomes = [
            Income(id: 1, userId: 1, title: "Salary", methodId: 4, createdDate: Date(), amount: 2000),
            Income(id: 2, userId: 1, title: "Freelance", methodId: 3, createdDate: Date(), amount: 500)
        ]
        
        // Spending
        c.spendingVM.spendings = [
            Spending(id: 1, userId: 1, title: "Subscriptions", categoryId: 20, methodId: 2, createdDate: Date(), amount: 30),
            Spending(id: 2, userId: 1, title: "Diesel 46L", categoryId: 17, methodId: 2, createdDate: Date(), amount: 68),
            Spending(id: 3, userId: 1, title: "Pills for alergy", categoryId: 18, methodId: 2, createdDate: Date(), amount: 20)
        ]
        
        c.spendingVM.totalSpentByCategory = [
            CategorySpending(categoryId: 15, total: 100),
            CategorySpending(categoryId: 16, total: 50),
            CategorySpending(categoryId: 17, total: 150),
            CategorySpending(categoryId: 18, total: 600),
            CategorySpending(categoryId: 19, total: 0),
            CategorySpending(categoryId: 20, total: 10)
        ]
        
        // Budget
        c.budgetVM.budgets = [
            Budget(id: 1, categoryId: 15, createdDate: Date(), amount: 300),
            Budget(id: 2, categoryId: 16, createdDate: Date(), amount: 200),
            Budget(id: 3, categoryId: 17, createdDate: Date(), amount: 150),
            Budget(id: 4, categoryId: 18, createdDate: Date(), amount: 150)
        ]
        
        //History
        c.historyVM.budgets = c.budgetVM.budgets
        c.historyVM.incomes = c.incomeVM.incomes
        c.historyVM.spendings = c.spendingVM.spendings
        
        return c
    }()


    // MARK: - Body

    var body: some View {
        content
            .environment(containers)
            .environment(methodVM)
    }
}
