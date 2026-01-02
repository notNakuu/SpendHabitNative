//
//  ProfileView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct ProfileView: View {
    @State var user: User
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
        incomeVM.allTimeIncome - spendingVM.allTimeSpent
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
                
                GeneralStatsView(user: user, totalSpent: spendingVM.allTimeSpent, totalSaved: totalSaved)
                
                NavToMyCategoriesView(user: user)
                
                TotalByCategoryView(user: user)
                
                VStack{
                    CategorySpendingPieSectionView(
                        data: spendingVM.totalSpentByCategory
                    )
                }
                .padding(.vertical, 20)
                
            }
            .scrollIndicators(.hidden)
            .navigationTitle("\(user.firstName) \(user.lastName)")
            .navigationBarTitleDisplayMode(.large)
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
