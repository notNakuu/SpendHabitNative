//
//  MonthlySpendingChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/1/26.
//

import SwiftUI

struct MonthlyChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    
    var incomeVM: IncomeViewModel { containers.incomeVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    
    @State private var selectedType: MonthlyChartType = .combined
    
    var headerText: String {
        switch selectedType{
            case .spending:
                return "spendings"
            case .income:
                return "incomes"
            case .combined:
                return "combined"
        }
    }
    
    var body: some View {
        
        // Header
        HStack {
            Text("Monthly \(headerText)")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Picker("", selection: $selectedType) {
                ForEach(MonthlyChartType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, -3)
        
        // Card
        VStack(alignment: .leading, spacing: 12) {
            
            switch selectedType {
                
            case .income:
                MonthlyBarView(
                    data: incomeVM.monthlyIncomesByMonth
                )
                
            case .spending:
                MonthlyBarView(
                    data: spendingVM.monthlySpendingByMonth
                )
                
            case .combined:
                HStack(spacing: 16) {
                    Spacer()
                    LegendItem(color: .blue, title: "Income")
                    LegendItem(color: .red, title: "Spending")
                    Spacer()
                }
                .padding(.horizontal, 4)
                
                SpendingVSIncomeBarChartView(
                    incomes: incomeVM.monthlyIncomesByMonth,
                    spendings: spendingVM.monthlySpendingByMonth
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
        )
    }
    
    private struct LegendItem: View {
        let color: Color
        let title: String
        
        var body: some View {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    PreviewContainer {
        MonthlyChartView()
    }
}
