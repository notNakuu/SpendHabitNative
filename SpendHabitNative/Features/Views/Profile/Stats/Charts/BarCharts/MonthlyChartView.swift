//
//  MonthlySpendingChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/1/26.
//

import SwiftUI

struct MonthlyChartView: View {
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedType: MonthlyChartType = .income
    
    private var data: [(month: String, total: Double)] {
        switch selectedType {
        case .income:
            return incomeVM.monthlyIncomesByMonth
        case .spending:
            return spendingVM.monthlySpendingByMonth
        }
    }
    
    var body: some View {
        
        // Header
        HStack {
            Text("Monthly \(selectedType.self == .income ? "Income" : "Spending")")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Picker("", selection: $selectedType) {
                ForEach(MonthlyChartType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            //.frame(width: 200)
        }
        .padding(.horizontal, 20)
        
        // Card
        VStack(alignment: .leading, spacing: 12) {
            MonthlyBarView(data: data)
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
        MonthlyChartView()
    }
}
