//
//  RecentIncomesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct RecentIncomesView: View {
    let user: User
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    var incomeVM: IncomeViewModel { containers.incomeVM }

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 12) {

                    HStack {
                        Text("Recent incomes")
                            .font(.title3)
                            .bold()

                        Spacer()

                        NavigationLink {
                            IncomesListView(user: user)
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

                    if incomeVM.incomes.isEmpty {
                        Text("No recent incomes")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(incomeVM.incomes.prefix(2)) { income in
                            TransactionRowView(
                                transaction: TransactionMapper.from(
                                    income: income,
                                    methodVM: methodVM
                                )
                            )

                            if income.id != incomeVM.incomes.prefix(2).last?.id {
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
}

#Preview {
    PreviewContainer{
        RecentIncomesView(user: User.mock)
    }
}
