//
//  NavToHistorySpendingsView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 28/12/25.
//

import SwiftUI

struct NavToHistoryView: View {
    let user: User
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                NavigationLink(destination: HistoryListView(user: user)) {
                    HStack{
                        Text("Your History")
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
        NavToHistoryView(user: User.mock)
    }
}
