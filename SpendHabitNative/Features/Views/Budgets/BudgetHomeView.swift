//
//  BudgetHomeVIew.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 30/12/25.
//

import SwiftUI

struct BudgetHomeView: View {
    @State var user: User
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    BudgetSpendingMonthPieChartView()
                    
                    BudgetsListView(user: user)
                        .padding(.vertical, 12)
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    PreviewContainer {
        BudgetHomeView(user: User.mock)
    }
}
