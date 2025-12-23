//
//  CategorySpendingPieSectionView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct CategorySpendingPieSectionView: View {
    let data: [CategorySpending]
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(SpendingViewModel.self) var spendingVM

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
            
            ForEach(data, id: \.categoryId) { item in
                let category = categoryVM.categories.first { $0.id == item.categoryId }

                HStack {
                    Circle()
                        .fill(Color(hex: category?.colorHex ?? "#000"))
                        .frame(width: 10, height: 10)

                    Text(category?.name ?? "Unknown")
                        .font(.headline)

                    Spacer()

                    Text("\(Double((item.total / spendingVM.allTimeSpent) * 100), specifier: "%.2f")%")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

        }
        .padding()
        .background(.background)
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
