//
//  IncomeRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct IncomeRowView: View {
    var income: Income
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM

    var incomeVM: IncomeViewModel { containers.incomeVM }
    
    var method: Method? {
        methodVM.methods.first { $0.id == income.methodId }
    }

    var color: Color {
        Color(hex: method?.colorHex ?? "#000000")
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = method?.iconKey {
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            Text(income.title)
                .font(.headline)
            Spacer()
            Text("\(income.amount, specifier: "%.2f") €")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PreviewContainer{
        IncomeRowView(income: Income(id: 1, userId: 1, title: "Test", methodId: 2, createdDate: .now, amount: 200))
    }
}
