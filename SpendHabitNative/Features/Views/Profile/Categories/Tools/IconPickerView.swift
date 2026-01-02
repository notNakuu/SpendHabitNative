//
//  IconPickerView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) var dismiss

    let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(categorySymbols, id: \.self) { icon in
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.clear)
                        )
                        .onTapGesture {
                            selectedIcon = icon
                            dismiss()
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Select Icon")
    }
}

