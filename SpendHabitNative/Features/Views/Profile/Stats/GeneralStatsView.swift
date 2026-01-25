//
//  GeneralStatsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct GeneralStatsView: View {
    let user: User
    let totalSpent: Double
    let totalSaved: Double
    @Environment(\.colorScheme) var colorScheme

    var averageSpending: Double {
        totalSpent / Double(user.monthsRegistered+1)
    }

    var averageSaving: Double {
        totalSaved / Double(user.monthsRegistered+1)
    }

    var body: some View {
        HStack{
            Text("General Stats Since Using App")
                .font(.headline)
                .padding(.horizontal, 30)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 5)
        
        VStack(alignment: .leading, spacing: 12) {
            statRow(title: "Total spent:", value: totalSpent)
            Divider()
            statRow(title: "Total saved:", value: totalSaved)
            Divider()
            statRow(title: "Average spent:", value: averageSpending)
            Divider()
            statRow(title: "Average saved:", value: averageSaving)
        }
        .padding()
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal)
    }

    private func statRow(title: String, value: Double) -> some View {
        HStack {
            Text(title)
                //.font(.callout)
                .bold()
            Spacer()
            Text("\(value.formatted()) €")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
    }
}


#Preview {
    GeneralStatsView(user: User.mock, totalSpent: 1000, totalSaved: 400)
}
