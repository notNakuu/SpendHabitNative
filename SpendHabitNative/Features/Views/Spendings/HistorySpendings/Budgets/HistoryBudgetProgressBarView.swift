//
//  BudgetProgressBarView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 15/12/25.
//

import SwiftUI

struct HistoryBudgetProgressBarView: View {
    let progress: Double       // 0.0 → 1.0
    let color: Color
    let height: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background (not spent)
                RoundedRectangle(cornerRadius: height)
                    .fill(color.opacity(0.3))
                    .frame(height: height)

                // Foreground (spent)
                RoundedRectangle(cornerRadius: height)
                    .fill(color)
                    .frame(
                        width: geo.size.width * min(progress, 1),
                        height: height
                    )
            }
        }
        .frame(height: height)
    }
}

