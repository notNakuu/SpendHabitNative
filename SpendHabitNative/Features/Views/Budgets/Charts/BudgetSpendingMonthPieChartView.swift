//
//  BudgetSpendingMonthPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/12/25.
//

import SwiftUI

struct BudgetSpendingMonthPieChartView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showWithBudget = true
    
    var body: some View {
        HStack {
            Text("This Month")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showWithBudget.toggle()
                }
            } label: {
                Text(showWithBudget ? "With budget" : "Without budget")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding(.horizontal, 20)
        VStack(alignment: .leading, spacing: 12) {
            if showWithBudget {
                WithBudgetView()
            }
            else{
                WithoutBudgetView()
            }
            
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
