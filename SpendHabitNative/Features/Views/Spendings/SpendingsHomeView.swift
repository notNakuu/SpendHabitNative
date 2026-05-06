//
//  SpendingsHomeView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 27/12/25.
//

import SwiftUI

struct SpendingsHomeView: View {
    let user: User
    @State private var isVisible = false
    @Environment(AppContainers.self) var containers
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing){
                ScrollView{
                    VStack{
                        TotalPieChartView()
                        
                        RecentSpendingsView(user: user)
                            .padding(.vertical, 12)
                        
                        DailySpendingChartSectionView()
                        
                        NavToHistoryView(user: user)
                            .padding(.vertical, 16)
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                
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
                NewSpendingView(user: user) {
                    Task{
                        await spendingVM.loadSpendings(for: user)
                    }
                }
                .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
                .presentationDetents([.fraction(0.5)])
            }
        }
        
    }
}

#Preview {
    PreviewContainer{
        SpendingsHomeView(user: User.mock)
    }
}
