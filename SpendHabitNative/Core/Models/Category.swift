//
//  Category.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation

    struct Category: Codable{
        let id: Int
        let iconKey: String
        let colorHex: String
        let name: String
        let isEnabled: Bool
    }
