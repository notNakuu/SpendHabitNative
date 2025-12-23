//
//  TransactionsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(\.colorScheme) var colorScheme
    var transactions: [Transaction]
    var body: some View {
        VStack(alignment: .leading){
            Text("Recent Transactions")
                .font(.title2.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            Divider()
            VStack{
                if transactions.isEmpty {
                    Text("No recent transactions")
                        .foregroundStyle(.secondary)
                        .padding()
                }
                else{
                    ForEach(transactions.indices, id: \.self){ index in
                        TransactionRowView(transaction: transactions[index])
                        if index != transactions.count - 1 {
                            Divider()
                        }
                            
                    }
                    .padding(.horizontal, 20)
                }
            }
            
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .padding()
    
    }
}

#Preview {
    let tras: [Transaction] = [
        Transaction(title: "Salary", iconKey: "building.columns.fill", amount: 1100, isIncome: true, date: .now),
        Transaction(title: "Diesel", iconKey: "car.fill", amount: 30, isIncome: false, date: .now)
    ]
    TransactionsView(transactions: tras)
}
