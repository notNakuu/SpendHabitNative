//
//  BudgetRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 15/12/25.
//

import SwiftUI

struct HistoryBudgetRowView: View {
    var budget: Budget
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var historyVM: HistoryViewModel { containers.historyVM }
    
    var category: Category? {
        categoryVM.categories.first { $0.id == budget.categoryId }
    }

    var color: Color {
        Color(hex: category?.colorHex ?? "#000000")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            let hasBudget = budget.amount > 0
            
            let spent = historyVM.totalSpentMonthlyForEachCategory[budget.categoryId] ?? 0
            let progress = hasBudget ? min(spent / budget.amount, 1) : 1
            
            let isOverBudget = hasBudget && spent > budget.amount
            
            let barColor: Color = isOverBudget ? .red : color

            HStack(spacing: 12) {
                if let icon = category?.iconKey {
                    if isOverBudget {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .frame(width: 35)
                        }
                    else{
                        Image(systemName: icon)
                            .foregroundStyle(color)
                            .frame(width: 35)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(category?.name ?? "Unknown category")
                            .font(.headline)

                        Spacer()

                        Text(hasBudget
                             ? "\(spent.formatted()) / \(budget.amount.formatted())"
                             : "No budget")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                    }

                    if hasBudget {
                        BudgetProgressBarView(
                            progress: progress,
                            color: barColor
                        )
                    } else {
                        BudgetProgressBarView(
                            progress: 1,
                            color: barColor.opacity(0.2)
                        )
                    }

                }
            }
        }
        
    }
}

#Preview {
    PreviewContainer{
        HistoryBudgetRowView(budget: Budget.mock)
    }
}
