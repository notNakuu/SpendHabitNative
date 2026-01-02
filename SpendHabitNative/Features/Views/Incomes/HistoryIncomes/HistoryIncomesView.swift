//
//  HistoryIncomesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct HistoryIncomesView: View {
    @State var user: User
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PreviewContainer{
        HistoryIncomesView(user: User.mock)
    }
}
