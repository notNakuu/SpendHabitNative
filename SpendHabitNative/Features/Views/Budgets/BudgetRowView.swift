//
//  BudgetRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 15/12/25.
//

import SwiftUI

struct BudgetRowView: View {
    @State var budget: Budget
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    @Environment(SpendingViewModel.self) var spendingVM
    
    var category: Category? {
        categoryVM.categories.first { $0.id == budget.categoryId }
    }

    var color: Color {
        Color(hex: category?.colorHex ?? "#000000")
    }
    
    var body: some View {
        VStack(spacing: 8) {
            let hasBudget = budget.amount > 0
            
            let spent = spendingVM.totalSpentForEachCategory[budget.categoryId] ?? 0
            let progress = hasBudget ? min(spent / budget.amount, 1) : 1
            
            let isOverBudget = hasBudget && spent > budget.amount
            
            let barColor: Color = isOverBudget ? .red : color

            HStack(spacing: 12) {
                if let icon = category?.iconKey {
                    if isOverBudget {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.caption)
                        }
                    else{
                        Image(systemName: icon)
                            .foregroundStyle(color)
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
        BudgetRowView(budget: Budget.mock)
    }
}
