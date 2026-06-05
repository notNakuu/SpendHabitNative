//
//  RecentIncomesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct HistoryRecentIncomesView: View {
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    var historyVM: HistoryViewModel { containers.historyVM }

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Text("Last incomes")
                        .font(.title3)
                        .bold()

                    Spacer()

                    NavigationLink {
                        HistoryIncomesListView()
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

                if historyVM.incomes.isEmpty {
                    Text("No recent incomes")
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 20)
                } else {
                    ForEach(historyVM.incomes.sorted { $0.createdDate > $1.createdDate }.prefix(1)) { income in
                        TransactionRowView(
                            transaction: TransactionMapper.from(
                                income: income,
                                methodVM: methodVM
                            )
                        )

                        if income.id != historyVM.incomes.sorted(by: { $0.createdDate > $1.createdDate }).prefix(1).last?.id {
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
        HistoryRecentIncomesView()
    }
}
