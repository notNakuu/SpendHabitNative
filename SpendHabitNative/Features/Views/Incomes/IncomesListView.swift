//
//  IncomesListView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import SwiftUI

struct IncomesListView: View {
    @State var user: User
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(\.colorScheme) var colorScheme
    @State private var isVisible = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack {
                if incomeVM.isLoading {
                    Text("Loading…")
                } else if let error = incomeVM.errorMessage {
                    Text("Error: \(error)")
                } else {
                    List {
                        ForEach(incomeVM.incomes, id: \.id) { income in
                            VStack(alignment: .leading){
                                Text("Title: \(income.title)")
                                Text("Amount \(income.amount.formatted()) Eur")
                            }
                        }
                    }
                    .navigationTitle("Incomes")
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
            NewIncomeView(user: user) {
                Task{
                    await incomeVM.loadIncomes(user: user)
                }
            }
            .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
            .presentationDetents([.fraction(0.4)])
        }
        
    }
}


#Preview {
    PreviewContainer{
        IncomesListView(user: User.mock)
    }
}

