//
//  BudgetSpendingMonthPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/12/25.
//

import SwiftUI

struct HistoryPieChartSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HistoryPieChartView()
            
        }
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
        )
    }
}

#Preview {
    PreviewContainer{
        HistoryPieChartSectionView()
    }
}
