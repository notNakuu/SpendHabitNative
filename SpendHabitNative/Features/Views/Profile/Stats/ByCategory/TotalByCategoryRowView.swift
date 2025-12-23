//
//  TotalByCategoryRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/12/25.
//

import SwiftUI

struct TotalByCategoryRowView: View {
    @Environment(CategoryViewModel.self) var categoryVM
    var cs: CategorySpending
    
    var category: Category? {
        categoryVM.categories.first { $0.id == cs.categoryId }
    }

    var color: Color {
        Color(hex: category?.colorHex ?? "#000000")
    }

    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = category?.iconKey {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .frame(width: 32, height: 32)
                    .background(
                        (color.opacity(0.2))
                    )
                    .clipShape(Circle())
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category?.name ?? "Unknown category")
                        .font(.headline)

                    Spacer()

                    Text("\(cs.total, specifier: "%.2f") €")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                }
            }
        }
    }
}

#Preview {
    PreviewContainer{
        TotalByCategoryRowView(cs: CategorySpending(categoryId: 16, total: 100))
    }
}
