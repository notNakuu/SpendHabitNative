//
//  MonthlySpendingChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/1/26.
//

import SwiftUI

struct MonthlyIncomeChartView: View {
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        // Section header
        HStack {
            Text("Monthly Incomes")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)

        // Card
        VStack(alignment: .leading, spacing: 12) {

            MonthlyIncomeBarView(
                data: incomeVM.monthlyIncomesByMonth
            )

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
        )
    }
}

#Preview {
    PreviewContainer {
        MonthlyIncomeChartView()
    }
}
