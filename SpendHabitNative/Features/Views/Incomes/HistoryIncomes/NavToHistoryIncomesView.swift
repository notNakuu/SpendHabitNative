//
//  NewToHistoryIncomesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct NavToHistoryIncomesView: View {
    let user: User
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                NavigationLink(destination: HistoryIncomesView(user: user)) {
                    HStack{
                        Text("History of Incomes")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .padding()
                }
            }
            .background(colorScheme == .light ? .white : .gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
    }
}

#Preview {
    PreviewContainer{
        NavToHistoryIncomesView(user: User.mock)
    }
}
