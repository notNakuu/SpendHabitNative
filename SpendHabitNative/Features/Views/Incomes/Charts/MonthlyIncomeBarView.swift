//
//  MonthlySpendingBarView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/1/26.
//

import SwiftUI

struct MonthlyIncomeBarView: View {
    let data: [(month: String, total: Double)]

    private let chartHeight: CGFloat = 140
    private let barWidth: CGFloat = 40

    private var maxValue: Double {
        let max = data.map(\.total).max() ?? 0
        return max == 0 ? 1 : max
    }

    private var yAxisSteps: [Double] {
        let step = maxValue / 3
        return [step, step * 2, step * 3]
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {

            // 🟦 Y AXIS
            VStack {
                ForEach(yAxisSteps.reversed(), id: \.self) { value in
                    Text("\(Int(value))€")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(height: chartHeight / 3, alignment: .top)
                }
            }
            .frame(width: 40)

            // 📊 BARS
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(data, id: \.month) { item in
                        VStack(spacing: 6) {

                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.blue)
                                .frame(
                                    width: barWidth,
                                    height: barHeight(for: item.total)
                                )

                            // Day label — now fits 2 digits
                            Text("\(item.month)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .frame(width: barWidth)
                        }
                    }
                }
                .padding(.trailing, 8)
            }
        }
        .frame(height: chartHeight + 30)
    }

    private func barHeight(for value: Double) -> CGFloat {
        CGFloat(value / maxValue) * chartHeight
    }
}

#Preview {
    PreviewContainer{
        MonthlyIncomeBarView(data: [("Jan 25", 100), ("Feb 25", 150),
                                      ("Mar 25", 120), ("Apr 25", 180),
                                      ("May 25", 120), ("Jun 25", 180),
                                      ("Jul 25", 120), ("Aug 25", 180),
                                      ("Sep 25", 120), ("Oct 25", 180),
                                      ("Nov 25", 120), ("Dec 25", 180),
                                      ("Jan 26", 120)])
    }
}
