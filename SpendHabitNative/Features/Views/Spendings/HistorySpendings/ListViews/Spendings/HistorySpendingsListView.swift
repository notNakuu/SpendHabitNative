//
//  SpendingsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import SwiftUI

struct HistorySpendingsListView: View {
    let user: User
    var month: YearMonth
    @Environment(AppContainers.self) var containers
    var historyVM: HistoryViewModel { containers.historyVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedSpending: Spending? = nil
    
    var body: some View {
        VStack {
            if historyVM.isLoading {
                Text("Loading…")
            } else if let error = historyVM.errorMessage {
                Text("Error: \(error)")
            } else {
                // Group spendings by day
                let groupedSpendings = Dictionary(grouping: historyVM.spendings) { spending in
                    // Extract just the day/month/year part of the date
                    Calendar.current.startOfDay(for: spending.createdDate)
                }

                List {
                    ForEach(groupedSpendings.keys.sorted(by: >), id: \.self) { day in
                        Section {
                            let spendingsForDay = groupedSpendings[day] ?? []
                            ForEach(spendingsForDay, id: \.id) { spending in
                                SpendingRowView(spending: spending)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedSpending = spending
                                    }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let spendingToDelete = spendingsForDay[index]
                                    Task {
                                        await historyVM.deleteHistorySpending(spending: spendingToDelete)
                                    }
                                }
                            }
                        } header: {
                            let spendingsForDay = groupedSpendings[day] ?? []
                            let totalForDay = spendingsForDay.reduce(0) { $0 + $1.amount }

                            HStack {
                                Text(dayFormatted(day))
                                
                                Spacer()
                                
                                Text("Total \(totalForDay, specifier: "%.2f")€")
                            }
                        }
                    }

                    
                }
                .navigationTitle("Spendings")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .sheet(item: $selectedSpending) { spending in
            EditSpendingView( user: user, spending: spending){
                Task{
                    await historyVM.loadHistory(user: user, year: month.year, month: month.month)
                }
            }
            .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
            .presentationDetents([.fraction(0.55)])
        }
    }

    // Helper function to format the date for the section header
    func dayFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // e.g., "Dec 28, 2025"
        return formatter.string(from: date)
    }

}


#Preview {
    PreviewContainer{
        HistorySpendingsListView(user: User.mock, month: YearMonth(year: 2026, month: 3))
    }
}
