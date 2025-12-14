//
//  BudgetsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import SwiftUI

struct BudgetsListView: View {
    @State var user: User
    @Environment(BudgetViewModel.self) var budgetVM
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedBudget: Budget? = nil


    var totalToSave: Double{
        incomeVM.totalIncome - budgetVM.totalToSpend
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(budgetVM.budgets, id: \.id) { budget in
                    let category = category(for: budget)

                    HStack(spacing: 12) {
                        if let icon = category?.iconKey {
                            Image(systemName: icon)
                                .foregroundStyle(
                                    Color(hex: category?.colorHex ?? "#000000")
                                )
                        }

                        VStack(alignment: .leading) {
                            Text(category?.name ?? "Unknown category")
                                .font(.headline)

                            Text("Amount: \(budget.amount.formatted())")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle()) // Make whole row tappable
                    .onTapGesture {
                        selectedBudget = budget
                    }
                }
            }
            .navigationTitle(Text("To save: \(totalToSave.formatted())$"))
            // Present the sheet when selectedBudget is non-nil
            .sheet(item: $selectedBudget) { budget in
                UpdateBudgetView(budget: budget, user: user){
                    Task{
                        await budgetVM.getCurrentMonthBudgets(user: user)
                    }
                }
                    .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
                    .presentationDetents([.fraction(0.5)])
            }
            
            
        }
            
        }

        // Helper to get category
        func category(for budget: Budget) -> Category? {
            categoryVM.categories.first { $0.id == budget.categoryId }
        }

}

#Preview {
    PreviewContainer{
        BudgetsListView(user: User.mock)
    }
}
