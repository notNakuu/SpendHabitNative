//
//  TransactionRowView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction

    var formattedAmount: String {
        let sign = transaction.isIncome ? "+" : "-"
        return "\(sign)\(transaction.amount.formatted(.number.precision(.fractionLength(2)))) €"
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.iconKey)
                .font(.system(size: 18))
                .frame(width: 32, height: 32)
                .background(
                    (transaction.isIncome ? Color.blue : Color.red)
                        .opacity(0.15)
                )
                .clipShape(Circle())
                .foregroundColor(transaction.isIncome ? .blue : .red)

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.headline)
                
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(formattedAmount)
                    .font(.headline)
                    .foregroundColor(transaction.isIncome ? .blue : .red)
                Text(transaction.isIncome ? "Income" : "Spending")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    TransactionRowView(transaction: Transaction(title: "Salary", iconKey: "building.columns.fill", amount: 1100, isIncome: true, date: .now))
}
