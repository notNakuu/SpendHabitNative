//
//  CategorySpendingPieChart.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct CategorySpendingPieChartView: View {
    let data: [CategorySpending]
    
    @Environment(AppContainers.self) var containers

    var categoryVM: CategoryViewModel { containers.categoryVM }
    
    var total: Double {
        data.reduce(0) { $0 + $1.total }
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

                // 2. MAKE THE INTERIOR EMPTY
                //context.clip(to: maskPath, style: FillStyle(eoFill: true))

                // 3. Draw segments
                var startAngle = Angle.zero
                for item in data {
                    let fraction = item.total / max(total, 0.0001)
                    let endAngle = startAngle + Angle(degrees: 360 * fraction)
                    let category = categoryVM.categories.first { $0.id == item.categoryId }
                    let color = Color(hex: category?.colorHex ?? "#000000")

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
    PreviewContainer{
        CategorySpendingPieChartView(data: [
            CategorySpending(categoryId: 15, total: 100),
            CategorySpending(categoryId: 16, total: 10),
            CategorySpending(categoryId: 17, total: 500),
            CategorySpending(categoryId: 18, total: 50),
            CategorySpending(categoryId: 19, total: 0)
        ])
    }
}
