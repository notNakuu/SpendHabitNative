//
//  HistorySpendingsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct HistorySpendingsView: View {
    @State var user: User
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PreviewContainer{
        HistorySpendingsView(user: User.mock)
    }
}
