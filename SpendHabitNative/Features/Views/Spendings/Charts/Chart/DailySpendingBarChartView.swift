//
//  DailySpendingBarChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct DailySpendingBarChartView: View {
    let data: [(day: Int, total: Double)]

    private let chartHeight: CGFloat = 140
    private let barWidth: CGFloat = 24

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
                    ForEach(data, id: \.day) { item in
                        VStack(spacing: 6) {

                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.blue)
                                .frame(
                                    width: barWidth,
                                    height: barHeight(for: item.total)
                                )

                            // Day label — now fits 2 digits
                            Text("\(item.day)")
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
        DailySpendingBarChartView(data: [(1, 100), (2, 150),
                                         (3, 120), (4, 180),
                                         (5, 120), (6, 180),
                                         (7, 120), (8, 180),
                                         (9, 120), (10, 180),
                                         (11, 120), (12, 180),
                                         (13, 120), (14, 180),
                                         (15, 120), (16, 180),
                                         (17, 120), (18, 180),
                                         (19, 120), (20, 180)])
    }
}
