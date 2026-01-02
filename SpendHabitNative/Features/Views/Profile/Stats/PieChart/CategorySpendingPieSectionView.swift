//
//  CategorySpendingPieSectionView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct CategorySpendingPieSectionView: View {
    let data: [CategorySpending]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(SpendingViewModel.self) var spendingVM
    
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack{
            Text("Total Spent Pie Chart")
                .font(.headline)
                .padding(.horizontal, 30)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 5)
        VStack(alignment: .leading, spacing: 12) {
            

            CategorySpendingPieChartView(
                data: data
            )
            .frame(height: 220)
            
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(data, id: \.categoryId) { item in

                    let category = categoryVM.categories.first { $0.id == item.categoryId }
                    let percentage = (item.total / max(spendingVM.allTimeSpent, 0.01)) * 100

                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(hex: category?.colorHex ?? "#9E9E9E"))
                            .frame(width: 10, height: 10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(category?.name ?? "Unknown")
                                .font(.headline)
                                .lineLimit(1)

                            Text("\(percentage, specifier: "%.2f") %")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(8)
                }
            }
            .padding()

            

        }
        .padding()
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))
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
