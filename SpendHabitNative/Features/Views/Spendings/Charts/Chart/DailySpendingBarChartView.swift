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
    private let numberOfSteps: Int = 3
    
    // MARK: - Computed Values
    
    private var maxValue: Double {
        let max = data.map(\.total).max() ?? 0
        return max == 0 ? 1 : max
    }
    
    private var yAxisSteps: [Double] {
        let step = maxValue / Double(numberOfSteps)
        return (1...numberOfSteps).map { Double($0) * step }
    }
    
    private var stepHeight: CGFloat {
        chartHeight / CGFloat(numberOfSteps)
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            // 🟦 Y AXIS
            VStack(spacing: 0) {
                ForEach(yAxisSteps.reversed(), id: \.self) { value in
                    Text("\(Int(value))€")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(height: stepHeight, alignment: .top)
                }
            }
            .frame(width: 45, height: chartHeight)
            .padding(.vertical, 16)
            
            // 📊 CHART AREA
            ZStack(alignment: .bottomLeading) {
                
                // 🔹 GRID LINES
                VStack(spacing: 0) {
                    ForEach(1...4, id: \.self) { _ in
                        ZStack(alignment: .top) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 1)
                        }
                        .frame(height: stepHeight, alignment: .top)
                    }
                }
                .frame(height: chartHeight - 8)
                
                // 🔹 BARS
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
            .frame(height: chartHeight)
        }
        .frame(height: chartHeight + 30)
    }
    
    // MARK: - Helpers
    
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
