//
//  MonthlyChartType.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 1/3/26.
//

import Foundation

enum MonthlyChartType: String, CaseIterable, Identifiable {
    case income = "T. Inc"
    case combined = "T. Inc/Sp"
    case spending = "T. Sp"
    
    var id: String { rawValue }
}
