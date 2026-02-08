//
//  CategoryOverviewSectionView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/1/26.
//

import SwiftUI

struct CategoryOverviewSectionView: View {
    let user: User
    let data: [CategorySpending]

    @State private var selection: Int = 0
    @State private var heights: [Int: CGFloat] = [:]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 12) {

            HStack {
                Text("Spending by Category")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 30)

            TabView(selection: $selection) {

                TotalByCategoryView(user: user)
                    .tag(0)
                    .readHeight { heights[0] = $0 }

                CategorySpendingPieSectionView(data: data)
                    .tag(1)
                    .readHeight { heights[1] = $0 }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: heights[selection] ?? 300)
            .animation(.easeInOut(duration: 0.25), value: selection)
        }
        .padding(.vertical, 5)
    }
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension View {
    func readHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewHeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(ViewHeightKey.self, perform: onChange)
    }
}




#Preview {
    PreviewContainer{
        CategoryOverviewSectionView(user: User.mock, data: [
            CategorySpending(categoryId: 15, total: 100),
            CategorySpending(categoryId: 16, total: 10),
            CategorySpending(categoryId: 17, total: 500),
            CategorySpending(categoryId: 18, total: 50),
            CategorySpending(categoryId: 19, total: 0)
        ])
    }
}
