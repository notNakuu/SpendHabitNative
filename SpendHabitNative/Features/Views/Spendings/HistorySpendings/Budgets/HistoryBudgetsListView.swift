//
//  BudgetsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import SwiftUI

struct HistoryBudgetsListView: View {
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var historyVM: HistoryViewModel { containers.historyVM }
    
    @Environment(\.colorScheme) var colorScheme

    var totalToSave: Double{
        var toSave: Double = 0
        let totalSpent = historyVM.totalSpending
        let totalToSpend = historyVM.totalBudget
        let totalIncome = historyVM.totalIncome
        
        if totalToSpend >= totalSpent {
            toSave = totalIncome - totalToSpend
        }
        else{
            toSave = totalIncome - totalSpent
        }
        if toSave < 0 {
            toSave = 0
        }
        
        return toSave
        
    }

    // Extract filtered budgets once (cleaner + faster)
    var visibleBudgets: [Budget] {
        historyVM.budgets.filter { budget in
            guard let category = categoryVM.categories.first(where: { $0.id == budget.categoryId }) else {
                return false
            }
            return category.isEnabled || budget.amount > 0
        }
    }

    var body: some View {
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
                        HistoryBudgetRowView(budget: budget)
                            .contentShape(Rectangle())

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
    }
}


#Preview {
    PreviewContainer{
        HistoryBudgetsListView()
    }
}
