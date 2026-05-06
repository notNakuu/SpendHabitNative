//
//  WithoutBudgetView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/03/2026.
//

import SwiftUI

struct WithoutBudgetView: View {
    @Environment(AppContainers.self) var containers
    
    var incomeVM: IncomeViewModel { containers.incomeVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    var budgetVM: BudgetViewModel { containers.budgetVM }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var difference: Double {
        incomeVM.totalMonthIncome - spendingVM.totalMonthlySpendings
    }

    var didOverSpent: Bool {
        difference < 0
    }

    var moneyLeft: Double {
        if difference > 0 {
            return difference
        }
        return 0
    }
    
    var moneyLeftText: Double{
        abs(difference)
    }
    
    var toSave: Double{
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
    
    var totalLeft: Double {
        return incomeVM.totalMonthIncome - spendingVM.totalMonthlySpendings
    }
    
    var body: some View {
        VStack{
            ZStack {
                MoneyLeftPieChartView(
                    data: [Color(.blue) : totalLeft, Color(.red) : spendingVM.totalMonthlySpendings]
                )
                .frame(height: 220)

                VStack(spacing: 4) {
                    Text(didOverSpent ? "Over spent" : "Remaining")
                        .font(.headline.bold())
                        .foregroundStyle(.primary)

                    Text("\(moneyLeftText, specifier: "%.2f") €")
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
                    .fill(Color(.blue))
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Total left")
                        .font(.subheadline.bold())

                    Text("\(totalLeft, specifier: "%.2f") €")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(spacing: 8) {
                Circle()
                    .fill(Color(.red))
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Total spent")
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
}

#Preview {
    PreviewContainer{
        WithoutBudgetView()
    }
}
