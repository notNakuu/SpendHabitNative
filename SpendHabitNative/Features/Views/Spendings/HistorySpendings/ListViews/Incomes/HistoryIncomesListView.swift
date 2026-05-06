//
//  IncomesListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import SwiftUI

struct HistoryIncomesListView: View {
    @Environment(AppContainers.self) var containers
    var historyVM: HistoryViewModel { containers.historyVM }

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if historyVM.isLoading {
                Text("Loading…")
            } else if let error = historyVM.errorMessage {
                Text("Error: \(error)")
            } else {
                // Group spendings by day
                let groupedIncomes = Dictionary(grouping: historyVM.incomes) { income in
                    // Extract just the day/month/year part of the date
                    Calendar.current.startOfDay(for: income.createdDate)
                }
                
                List {
                    ForEach(groupedIncomes.keys.sorted(by: >), id: \.self) { day in
                        Section {
                            let incomesForTheDay = groupedIncomes[day] ?? []
                            ForEach(incomesForTheDay, id: \.id) { income in
                                IncomeRowView(income: income)
                                    .contentShape(Rectangle())
                            }
                        }header: {
                            let incomesForTheDay = groupedIncomes[day] ?? []
                            let totalForDay = incomesForTheDay.reduce(0) { $0 + $1.amount }

                            HStack {
                                Text(dayFormatted(day))
                                
                                Spacer()
                                
                                Text("Total \(totalForDay, specifier: "%.2f")€")
                            }
                        }
                    }
                }
                .navigationTitle("Incomes")
                .navigationBarTitleDisplayMode(.large)
            }
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
        HistoryIncomesListView()
    }
}

