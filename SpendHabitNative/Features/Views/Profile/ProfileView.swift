//
//  ProfileView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @Environment(UserViewModel.self) var userVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(BudgetViewModel.self) var budgetVM
    @Environment(MethodViewModel.self) var methodVM
    
    @Environment(\.colorScheme) var colorScheme
    
    var recentTransactions: [Transaction] {
           let spendings = spendingVM.spendings.map {
               TransactionMapper.from(
                   spending: $0,
                   categoryVM: categoryVM
               )
           }

           let incomes = incomeVM.incomes.map {
               TransactionMapper.from(
                   income: $0,
                   methodVM: methodVM
               )
           }

           return (spendings + incomes)
               .sorted { $0.date > $1.date }
               .prefix(2)
               .map { $0 }
       }
    
    var totalSaved: Double {
        incomeVM.totalAllTimeIncome - spendingVM.allTimeSpent
    }
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){

                    HStack{
                        Text("\(user.username)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("User since \(user.registeredDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    Divider()
                }
                .padding(.horizontal, 20)
                
                TransactionsView(transactions: recentTransactions)
                
                GeneralStatsView(user: user,totalSpent: spendingVM.allTimeSpent, totalSaved: totalSaved, totalIncome: incomeVM.totalAllTimeIncome)
                
                NavToMyCategoriesView(user: user)
                
                CategoryOverviewSectionView(
                    user: user,
                    data: spendingVM.totalSpentByCategory
                )

                
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    VStack {
                        Button{
                                    
                        }label:{
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
            }
            .navigationTitle("\(user.firstName)")
            .background(colorScheme == .light ? .black.opacity(0.03) : .black)
            
        }
        .task{
            await spendingVM.loadTotalAmountSpent(for: user)
            await incomeVM.loadAllTimeIncomes(user: user)
        }
        
    }
}

#Preview {
    PreviewContainer{
        ProfileView(user: User.mock)
    }
}
