//
//  ProfileView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/12/25.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    
    var userVM: UserViewModel { containers.userVM}
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var incomeVM: IncomeViewModel { containers.incomeVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    var budgetVM: BudgetViewModel { containers.budgetVM }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var navigateToWelcome = false
    
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
                
                VStack {
                    MonthlyChartView()
                }
                .padding(12)
                
                NavToMyCategoriesView(user: user)
                
                VStack{
                    CategoryOverviewSectionView(
                        user: user,
                        data: spendingVM.totalSpentByCategory
                    )
                }
                .padding(.vertical, 12)

                
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationStack{
                        VStack {
                            Menu{
                                NavigationLink(destination: UserInfoView(user: user)) {
                                    HStack{
                                        Text("Edit User Info")
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                    }
                                }
                                Divider()
                                Button(role: .destructive){
                                    containers.resetApp()
                                    navigateToWelcome = true
                                } label: {
                                    Label("Logout", systemImage: "person.crop.circle")
                                }
                            }label:{
                                Image(systemName: "gearshape.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(user.firstName)")
            .background(colorScheme == .light ? .black.opacity(0.03) : .black)
            .navigationDestination(isPresented: $navigateToWelcome){
                WelcomeView()
            }
            
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
