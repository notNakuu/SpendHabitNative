//
//  IncomesHomeView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 29/12/25.
//

import SwiftUI

struct IncomesHomeView: View {
    @State var user: User
    @State private var isVisible = false
    
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(MethodViewModel.self) var methodVM
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing){
                ScrollView{
                    VStack{
                        MonthlyIncomesPieChartView()
                        
                        RecentIncomesView(user: user)
                            .padding(.vertical, 12)
                        
                        NavToHistoryIncomesView(user: user)
                    }
                    .padding()
                }
                
                Button{
                    isVisible.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .padding()
                        .background(Color(.blue).opacity(0.7))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 10)
                }
                .padding()
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
}

#Preview {
    PreviewContainer{
        IncomesHomeView(user: User.mock)
    }
}
