//
//  IncomesListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import SwiftUI

struct HistoryIncomesListView: View {
    let user: User
    @Environment(AppContainers.self) var containers
    var incomeVM: IncomeViewModel { containers.incomeVM }

    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false
    
    @State private var selectedIncome: Income? = nil
    
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
                        Section {
                            let incomesForTheDay = groupedIncomes[day] ?? []
                            ForEach(incomesForTheDay, id: \.id) { income in
                                IncomeRowView(income: income)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedIncome = income
                                    }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let incomeToDelete = incomesForTheDay[index]
                                    Task {
                                        await incomeVM.deleteIncome(income: incomeToDelete)
                                        
                                        if incomeVM.responseCode == 1 {
                                            await incomeVM.loadIncomes(user: user)
                                        }
                                    }
                                }
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
        .sheet(item: $selectedIncome) { income in
            EditIncomeView( user: user, income: income){
                Task{
                    await incomeVM.loadIncomes(user: user)
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
        IncomesListView(user: User.mock)
    }
}

