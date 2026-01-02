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
        incomeVM.totalMonthIncome - budgetVM.totalToSpend
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(budgetVM.budgets.filter { budget in
                    if let category = categoryVM.categories.first(where: { $0.id == budget.categoryId }) {
                        return category.isEnabled || budget.amount > 0
                    }
                    return false
                }, id: \.id) { budget in
                    BudgetRowView(budget: budget)
                        .contentShape(Rectangle())
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

}

#Preview {
    PreviewContainer{
        BudgetsListView(user: User.mock)
    }
}
