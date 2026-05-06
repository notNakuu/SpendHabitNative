//
//  CategorySpendingPieSectionView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct CategorySpendingPieSectionView: View {
    let data: [CategorySpending]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(AppContainers.self) var containers

    var categoryVM: CategoryViewModel { containers.categoryVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    

    var body: some View {
        VStack(spacing: 16) {

            // Chart
            CategorySpendingPieChartView(data: data)
                .frame(height: 220)

            // Legend
            ForEach(data, id: \.categoryId) { item in

                let category = categoryVM.categories.first { $0.id == item.categoryId }
                let percentage = (item.total / max(spendingVM.allTimeSpent, 0.01)) * 100

                HStack(spacing: 6) {

                    Circle()
                        .fill(Color(hex: category?.colorHex ?? "#9E9E9E"))
                        .frame(width: 8, height: 8)

                    Text(category?.name ?? "Unknown")
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    Text("\(percentage, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .light
                              ? Color.black.opacity(0.04)
                              : Color.white.opacity(0.06))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
        )
        .padding(.horizontal)
    }
}



#Preview {
    PreviewContainer{
        CategorySpendingPieSectionView(data: [
            CategorySpending(categoryId: 15, total: 100),
            CategorySpending(categoryId: 16, total: 10),
            CategorySpending(categoryId: 17, total: 500),
            CategorySpending(categoryId: 18, total: 50),
            CategorySpending(categoryId: 19, total: 0)
        ])
    }
}
