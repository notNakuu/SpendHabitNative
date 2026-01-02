//
//  Method.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation

struct Method: Codable{
    let id: Int
    let iconKey: String
    let name: String
}

extension Method {
    var colorHex: String {
        switch id {
        case 1: // Cash
            return "#4CAF50"   // green
        case 2: // Card
            return "#0F2B70"   // blue
        case 3: // Bizum
            return "#05C0C7"   // purple
        case 4: // Bank Transfer
            return "#FF9800"   // orange
        default:
            return "#9E9E9E"   // fallback gray
        }
    }
}

