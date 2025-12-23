//
//  Transaction.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import Foundation

struct Transaction{
    let title: String
    let iconKey: String
    let amount: Double
    let isIncome: Bool
    let date: Date
}

struct TransactionMapper {

    static func from(
        spending: Spending,
        categoryVM: CategoryViewModel
    ) -> Transaction {

        let category = categoryVM.categories.first {
            $0.id == spending.categoryId
        }

        return Transaction(
            title: spending.title,
            iconKey: category?.iconKey ?? "questionmark.circle",
            amount: spending.amount,
            isIncome: false,
            date: spending.createdDate
        )
    }

    static func from(
        income: Income,
        methodVM: MethodViewModel
    ) -> Transaction {

        let method = methodVM.methods.first {
            $0.id == income.methodId
        }

        return Transaction(
            title: income.title,
            iconKey: method?.iconKey ?? "banknote",
            amount: income.amount,
            isIncome: true,
            date: income.createdDate
        )
    }
}


