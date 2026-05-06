//
//  PastMonthSpendingView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 20/1/26.
//

import SwiftUI

struct HistoryView: View {
    let user: User
    var month: YearMonth
    
    @Environment(AppContainers.self) var containers
    var historyVM: HistoryViewModel { containers.historyVM }
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack{
                    HistoryPieChartSectionView()
                }
                .padding(.vertical, 5)
                
                VStack{
                    HistoryRecentSpendingsView(user: user, month: month)
                }
                .padding(.vertical, 5)
                
                VStack{
                    HistoryRecentIncomesView()
                }
                .padding(.vertical, 5)
                
                VStack{
                    HistoryBudgetsListView()
                }
                .padding(5)
            }
            .padding(.horizontal, 10)
            .task{
                await historyVM.loadHistory(user: user, year: month.year, month: month.month)
            }
            
        }
        .navigationTitle(month.displayName)
        .scrollIndicators(.hidden)
        .background(colorScheme == .light
                    ? Color(.secondarySystemBackground)
                    : Color(.systemBackground))
        
    }
    
}

#Preview {
    PreviewContainer{
        HistoryView(user: User.mock, month: YearMonth(year: 2026, month: 3))
    }
}
