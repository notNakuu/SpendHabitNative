//
//  SpendingRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

    struct SpendingRowView: View {
        var spending: Spending
        @Environment(\.colorScheme) var colorScheme
        @Environment(AppContainers.self) var containers
        
        var categoryVM: CategoryViewModel { containers.categoryVM }
        var spendingVM: SpendingViewModel { containers.spendingVM }
        
        var category: Category? {
            categoryVM.categories.first { $0.id == spending.categoryId }
        }

        var color: Color {
            Color(hex: category?.colorHex ?? "#000000")
        }
        
        var body: some View {
            HStack(spacing: 12) {
                if let icon = category?.iconKey {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                }
                Text(spending.title)
                    .font(.headline)
                Spacer()
                Text("\(spending.amount, specifier: "%.2f") €")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }

#Preview {
    PreviewContainer{
        SpendingRowView(spending: Spending.mock)
    }
}
