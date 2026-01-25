//
//  YearMonth.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 20/1/26.
//

import Foundation

struct YearMonth: Identifiable, Hashable {
    let year: Int
    let month: Int   // 1...12

    var id: String { "\(year)-\(month)" }

    var displayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"

        let date = Calendar.current.date(
            from: DateComponents(year: year, month: month)
        )!

        return formatter.string(from: date).capitalized
    }
}
