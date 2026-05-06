//
//  DailySpendingChartSectionView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct DailySpendingChartSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    
    var spendingVM: SpendingViewModel { containers.spendingVM }

    var body: some View {

        // Section header
        HStack {
            Text("Daily spending")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)

        // Card
        VStack(alignment: .leading, spacing: 12) {

            DailySpendingBarChartView(
                data: spendingVM.dailySpendingByDay
            )

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
        )
        //.padding(.horizontal, 10)
    }
}

#Preview {
    PreviewContainer {
        DailySpendingChartSectionView()
    }
}
