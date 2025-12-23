//
//  CategorySpendingPieChart.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct CategorySpendingPieChartView: View {
    let data: [CategorySpending]
    @Environment(CategoryViewModel.self) var categoryVM

    var total: Double {
        data.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        
        GeometryReader { geo in
            Canvas { context, size in
                var startAngle = Angle.zero

                for item in data {
                    let fraction = item.total / max(total, 0.0001)
                    let endAngle = startAngle + Angle(degrees: 360 * fraction)

                    let category = categoryVM.categories.first { $0.id == item.categoryId }
                    let color = Color(hex: category?.colorHex ?? "#000000")

                    let path = Path { p in
                        p.move(to: CGPoint(x: size.width / 2, y: size.height / 2))
                        p.addArc(
                            center: CGPoint(x: size.width / 2, y: size.height / 2),
                            radius: min(size.width, size.height) / 2,
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
