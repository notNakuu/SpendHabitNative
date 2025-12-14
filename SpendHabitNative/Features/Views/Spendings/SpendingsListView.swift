//
//  SpendingsListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import SwiftUI

struct SpendingsListView: View {
    var user: User
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false
    
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
            Button{
                isVisible.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .padding()
                    .background(Color.accentColor.opacity(0.7))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10)
            }
            .padding(30)
        }
        .sheet(isPresented: $isVisible) {
            NewSpendingView(user: user) {
                Task{
                    await spendingVM.loadSpendings(for: user)
                }
            }
            .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
            .presentationDetents([.fraction(0.6)])
        }
        
    }
}


#Preview {
    PreviewContainer{
        SpendingsListView(user: User.mock)
    }
}
