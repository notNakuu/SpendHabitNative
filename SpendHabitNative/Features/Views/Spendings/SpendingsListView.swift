//
//  SpendingsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import SwiftUI

struct SpendingsListView: View {
    var user: User
    @State var spendingVM = SpendingViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack {
                if spendingVM.isLoading {
                    Text("Loading…")
                } else if let error = spendingVM.errorMessage {
                    Text("Error: \(error)")
                } else {
                    List {
                        ForEach(spendingVM.spendings, id: \.id) { spending in
                            VStack(alignment: .leading){
                                Text("Title: \(spending.title)")
                                Text("Amount \(spending.amount.formatted()) Eur")
                            }
                        }
                    }
                    .navigationTitle("Spendings")
                }
            }
            .task(id: user.id) {  // <-- ensure task runs once per user
                await spendingVM.loadSpendings(for: user)
            }
            Button{
                
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .padding()
                    .background(Color.accentColor.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(30)
        }
    }
}


#Preview {
    SpendingsListView(user: User.mock)
}
