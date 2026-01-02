//
//  NavToHistorySpendingsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct NavToHistorySpendingsView: View {
    @State var user: User
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                NavigationLink(destination: HistorySpendingsView(user: user)) {
                    HStack{
                        Text("History of Spendings")
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
        NavToHistorySpendingsView(user: User.mock)
    }
}
