//
//  MethodIncomeMonthPieChartView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct MethodIncomeMonthPieChartView: View {
    let data: [Int: Double]
    @Environment(MethodViewModel.self) var methodVM

    var total: Double {
        data.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let outerRadius = min(size.width, size.height) / 2
                let innerRadius = outerRadius * 0.6

                // 1. Create the path for the hole
                var maskPath = Path()
                maskPath.addRect(CGRect(origin: .zero, size: size))
                maskPath.addEllipse(in: CGRect(
                    x: center.x - innerRadius,
                    y: center.y - innerRadius,
                    width: innerRadius * 2,
                    height: innerRadius * 2
                ))

                // 2. The Correct Fix: Use the FillStyle initializer
                context.clip(to: maskPath, style: FillStyle(eoFill: true))

                // 3. Draw segments
                var startAngle = Angle.zero
                for item in data {
                    let fraction = item.value / max(total, 0.0001)
                    let endAngle = startAngle + Angle(degrees: 360 * fraction)
                    let method = methodVM.methods.first { $0.id == item.key }
                    let color = Color(hex: method?.colorHex ?? "#000000")

                    let path = Path { p in
                        p.move(to: center)
                        p.addArc(
                            center: center,
                            radius: outerRadius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                    }

                    context.fill(path, with: .color(color))
                    startAngle = endAngle
                }
            }
        }
    }
}

#Preview {
    PreviewContainer {
        MethodIncomeMonthPieChartView(data: [1: 100, 2: 200, 3: 300, 4: 100])
    }
}
