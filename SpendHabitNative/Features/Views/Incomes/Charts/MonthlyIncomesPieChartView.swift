//
//  MonthlyIncomesPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct MonthlyIncomesPieChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    var incomeVM: IncomeViewModel { containers.incomeVM }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    
    var body: some View {
        HStack {
            Text("This Month")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)
        
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                VStack(alignment: .leading){
                    ForEach(
                        Array(incomeVM.totalMonthIncomeForEachMethod),
                        id: \.key) { key, total in

                        let method = methodVM.methods.first { $0.id == key }

                            HStack(spacing: 8) {
                            Circle()
                                .fill(Color(hex: method?.colorHex ?? "#9E9E9E"))
                                .frame(width: 10, height: 10)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(method?.name ?? "Unknown")
                                    .font(.subheadline.bold())

                                Text("\(total, specifier: "%.2f") €")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                }
                .padding()
                
                ZStack {
                    MethodIncomeMonthPieChartView(
                        data: incomeVM.totalMonthIncomeForEachMethod
                    )
                    .frame(height: 220)

                    VStack(spacing: 4) {
                        Text("Total")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)

                        Text("\(incomeVM.totalMonthIncome.formatted()) €")
                            .font(.title3.bold())
                    }
                }
                .padding(.vertical, 20)

            }
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        
    }
}

#Preview {
    PreviewContainer{
        MonthlyIncomesPieChartView()
    }
}
