//
//  RecentSpendingsVIew.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct RecentSpendingsView: View {
    let user: User
    @Environment(AppContainers.self) var containers
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 12) {

                    HStack {
                        Text("Recent spendings")
                            .font(.title3)
                            .bold()

                        Spacer()

                        NavigationLink {
                            SpendingsListView(user: user)
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

                    if spendingVM.spendings.isEmpty {
                        Text("No recent spendings")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(spendingVM.spendings.prefix(3)) { spending in
                            TransactionRowView(
                                transaction: TransactionMapper.from(
                                    spending: spending,
                                    categoryVM: categoryVM
                                )
                            )

                            if spending.id != spendingVM.spendings.prefix(3).last?.id {
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
        RecentSpendingsView(user: User.mock)
    }
}
