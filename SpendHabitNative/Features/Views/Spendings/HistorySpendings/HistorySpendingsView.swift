//
//  HistorySpendingsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct HistorySpendingsView: View {
    let user: User
    @Environment(SpendingViewModel.self) var spendingVM
    var body: some View {
            NavigationStack {
                Group {
                    if spendingVM.availablePastMonths.isEmpty {
                        
                        emptyState
                    } else {
                        monthList
                    }
                }
                .navigationTitle("Spending History")
            }
            .task {
                spendingVM.buildAvailablePastMonths(for: user)
            }
        }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("No history yet")
                .font(.headline)

            Text("Come back next month to see your spending history.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var monthList: some View {
        List {
            ForEach(spendingVM.availablePastMonths) { month in
                NavigationLink {
                    PastMonthSpendingView()
                } label: {
                    Text(month.displayName)
                }
            }
        }
    }


}

#Preview {
    PreviewContainer{
        HistorySpendingsView(user: User.mock)
    }
}
