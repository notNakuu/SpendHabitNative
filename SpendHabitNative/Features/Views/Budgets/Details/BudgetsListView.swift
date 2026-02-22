//
//  BudgetsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import SwiftUI

struct BudgetsListView: View {
    let user: User

    @Environment(BudgetViewModel.self) var budgetVM
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedBudget: Budget? = nil

    var totalToSave: Double{
        var toSave: Double = 0
        let totalSpent = spendingVM.totalMonthlySpendings
        let totalToSpend = budgetVM.totalToSpend
        
        if totalToSpend >= totalSpent {
            toSave = incomeVM.totalMonthIncome - budgetVM.totalToSpend
        }
        else{
            toSave = incomeVM.totalMonthIncome - spendingVM.totalMonthlySpendings
        }
        if toSave < 0 {
            toSave = 0
        }
        
        return toSave
        
    }

    // Extract filtered budgets once (cleaner + faster)
    var visibleBudgets: [Budget] {
        budgetVM.budgets.filter { budget in
            guard let category = categoryVM.categories.first(where: { $0.id == budget.categoryId }) else {
                return false
            }
            return category.isEnabled || budget.amount > 0
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 12) {

                        // Header
                        HStack {
                            Text("Budgets")
                                .font(.title3)
                                .bold()

                            Spacer()
                            
                            Text("To save: \(totalToSave, specifier: "%.2f") €")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .bold()
                        }

                        Divider()

                        // Content
                        if visibleBudgets.isEmpty {
                            Text("No budgets configured")
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 20)
                        } else {
                            ForEach(visibleBudgets) { budget in
                                BudgetRowView(budget: budget)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedBudget = budget
                                    }

                                if budget.id != visibleBudgets.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(colorScheme == .light ? .white : .gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                }
                //.padding()
            }
            .sheet(item: $selectedBudget) { budget in
                UpdateBudgetView(budget: budget, user: user) {
                    Task {
                        await budgetVM.getCurrentMonthBudgets(user: user)
                    }
                }
                .background(
                    colorScheme == .light
                    ? .white.opacity(0.8)
                    : .black.opacity(0.8)
                )
                .presentationDetents([.fraction(0.5)])
            }
        }
    }
}


#Preview {
    PreviewContainer{
        BudgetsListView(user: User.mock)
    }
}
