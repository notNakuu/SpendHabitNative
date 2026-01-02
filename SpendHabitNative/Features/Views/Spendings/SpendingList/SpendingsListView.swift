//
//  SpendingsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import SwiftUI

struct SpendingsListView: View {
    var user: User
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedSpending: Spending? = nil

    
    var body: some View {
        VStack {
            if spendingVM.isLoading {
                Text("Loading…")
            } else if let error = spendingVM.errorMessage {
                Text("Error: \(error)")
            } else {
                // Group spendings by day
                let groupedSpendings = Dictionary(grouping: spendingVM.spendings) { spending in
                    // Extract just the day/month/year part of the date
                    Calendar.current.startOfDay(for: spending.createdDate)
                }

                List {
                    // Sort days descending (most recent first)
                    ForEach(groupedSpendings.keys.sorted(by: >), id: \.self) { day in
                        Section(header: Text(dayFormatted(day))) {
                            ForEach(groupedSpendings[day] ?? [], id: \.id) { spending in
                                SpendingRowView(spending: spending)
                                    .contentShape(Rectangle()) // makes whole row tappable
                                    .onTapGesture {
                                        selectedSpending = spending
                                    }
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
                    await spendingVM.loadSpendings(for: user)
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
        SpendingsListView(user: User.mock)
    }
}
