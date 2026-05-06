//
//  WithBudgetView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/03/2026.
//

import SwiftUI

struct HistoryPieChartView: View {
    @Environment(AppContainers.self) var containers
    
    var historyVM: HistoryViewModel { containers.historyVM }

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var didOverSpend: Bool {
        historyVM.totalBudget < historyVM.totalSpending
    }
    
    var toSave: Double {
        historyVM.totalIncome - historyVM.totalBudget
    }
    
    var saved: Double{
        historyVM.totalIncome - historyVM.totalSpending
    }
    
    var budget: Double {
        let budget = historyVM.totalBudget - historyVM.totalSpending
        
        if budget > 0 {
            return budget
        }
        return 0
    }
    
    
    var body: some View {
        VStack{
            ZStack {
                MoneyLeftPieChartView(
                    data: [Color(.yellow) : toSave, Color(.blue) : budget, Color(.red) : historyVM.totalSpending]
                )
                .frame(height: 220)

                VStack(spacing: 4) {
                    Text("Total saved")
                        .font(.headline.bold())
                        .foregroundStyle(.primary)
                    Text("\(saved, specifier: "%.2f") €")
                        .font(.headline.bold())
                        .foregroundStyle(.primary)
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
                    Text("To save")
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

                    Text("\(historyVM.totalBudget, specifier: "%.2f") €")
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

                    Text("\(historyVM.totalSpending, specifier: "%.2f") €")
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
        HistoryPieChartView()
    }
}
