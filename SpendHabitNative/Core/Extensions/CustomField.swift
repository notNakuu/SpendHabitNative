//
//  CustomField.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 02/06/2026.
//

import SwiftUI

struct CustomField: View {

    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("", text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.tertiarySystemBackground))
                )
        }
    }
}
