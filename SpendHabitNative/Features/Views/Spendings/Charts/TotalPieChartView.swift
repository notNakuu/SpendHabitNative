//
//  TotalPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 27/12/25.
//

import SwiftUI

struct TotalPieChartView: View {
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showLegend = false
    
    var body: some View {
        HStack {
            Text("This Month")
                .font(.headline)
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showLegend.toggle()
                }
            } label: {
                Image(systemName: showLegend ? "list.bullet" : "list.bullet.rectangle")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)

        HStack {
            if showLegend {
                VStack(alignment: .leading){
                    ForEach(
                        Array(spendingVM.totalSpentMonthlyForEachCategory),
                        id: \.key
                    ) { key, total in
                        let category = categoryVM.categories.first { $0.id == key }
                        
                        let percentage = spendingVM.totalMonthlySpendings > 0
                        ? (total / spendingVM.totalMonthlySpendings) * 100
                            : 0


                        HStack {
                            Circle()
                                .fill(Color(hex: category?.colorHex ?? "#000"))
                                .frame(width: 10, height: 10)

                            VStack(alignment: .leading, spacing: 2){
                                Text(category?.name ?? "Unknown")
                                    .font(.subheadline)
                                    .bold()

                                Text("\(percentage, specifier: "%.1f")%")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding()
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            ZStack {
                CategorySpendingMonthPieChartView(
                    data: spendingVM.totalSpentMonthlyForEachCategory
                )
                .frame(height: showLegend ? 150 : 220)

                VStack(spacing: 4) {
                    Text("Total")
                        .font(showLegend ? .title2.bold() : .title.bold())

                    Text("\(spendingVM.totalMonthlySpendings.formatted()) €")
                        .font(showLegend ? .headline.bold() : .title2.bold())
                }
            }
        }
        .padding(20)
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))

        
    }
    
}

#Preview {
    PreviewContainer{
        TotalPieChartView()
    }
}
