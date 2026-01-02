//
//  BudgetSpendingMonthPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/12/25.
//

import SwiftUI

struct BudgetSpendingMonthPieChartView: View {
    
    @Environment(BudgetViewModel.self) var budgetVM
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(\.colorScheme) var colorScheme
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var moneyLeft: Double{
        budgetVM.totalToSpend - spendingVM.totalMonthlySpendings
    }
    
    var toSave: Double{
        incomeVM.totalMonthIncome - budgetVM.totalToSpend
    }
    
    var body: some View {
        HStack {
            Text("This Month")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)
        VStack(alignment: .leading, spacing: 12) {
            VStack{
                ZStack {
                    MoneyLeftPieChartView(
                        data: [Color(.yellow) : toSave, Color(.blue) : moneyLeft, Color(.red) : spendingVM.totalMonthlySpendings]
                    )
                    .frame(height: 220)

                    VStack(spacing: 4) {
                        Text("Left to spend")
                            .font(.headline.bold())
                            .foregroundStyle(.primary)

                        Text("\(moneyLeft, specifier: "%.2f") €")
                            .font(.title3.bold())
                    }
                }
                .padding(.top, 20)
            }
            
            Divider()
            
            HStack(alignment: .center, spacing: 16) {
                Spacer()
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(.yellow))
                        .frame(width: 10, height: 10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("To Save")
                            .font(.subheadline.bold())
                        
                        Text("\(toSave, specifier: "%.2f") €")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(.blue))
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Budgets")
                            .font(.subheadline.bold())

                        Text("\(budgetVM.totalToSpend, specifier: "%.2f") €")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(.red))
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Spendings")
                            .font(.subheadline.bold())

                        Text("\(spendingVM.totalMonthlySpendings, specifier: "%.2f") €")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}

#Preview {
    PreviewContainer{
        BudgetSpendingMonthPieChartView()
    }
}
