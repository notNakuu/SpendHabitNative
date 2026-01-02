//
//  IncomesListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import SwiftUI

struct IncomesListView: View {
    @State var user: User
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            if incomeVM.isLoading {
                Text("Loading…")
            } else if let error = incomeVM.errorMessage {
                Text("Error: \(error)")
            } else {
                // Group spendings by day
                let groupedIncomes = Dictionary(grouping: incomeVM.incomes) { income in
                    // Extract just the day/month/year part of the date
                    Calendar.current.startOfDay(for: income.createdDate)
                }
                
                List {
                    ForEach(groupedIncomes.keys.sorted(by: >), id: \.self) { day in
                        Section(header: Text(dayFormatted(day))) {
                            ForEach(groupedIncomes[day] ?? [], id: \.id) { income in
                                IncomeRowView(income: income)
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
        IncomesListView(user: User.mock)
    }
}

