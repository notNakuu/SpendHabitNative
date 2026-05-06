//
//  RecentSpendingsVIew.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct HistoryRecentSpendingsView: View {
    let user: User
    var month: YearMonth
    @Environment(AppContainers.self) var containers
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var historyVM: HistoryViewModel { containers.historyVM }
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Text("Last spendings")
                        .font(.title3)
                        .bold()

                    Spacer()

                    NavigationLink {
                        HistorySpendingsListView(user: user, month: month)
                    } label: {
                        Text("See all")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            
            Divider()

                if historyVM.spendings.isEmpty {
                    Text("No recent spendings")
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 20)
                } else {
                    ForEach(historyVM.spendings.prefix(2)) { spending in
                        TransactionRowView(
                            transaction: TransactionMapper.from(
                                spending: spending,
                                categoryVM: categoryVM
                            )
                        )

                        if spending.id != historyVM.spendings.prefix(2).last?.id {
                            Divider()
                        }
                    }
                }
            }
            .padding()
            .background(colorScheme == .light ? .white : .gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}

#Preview {
    PreviewContainer{
        HistoryRecentSpendingsView(user: User.mock, month: YearMonth(year: 2026, month: 3))
    }
}
