//
//  MainView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import SwiftUI
import Observation

struct MainView: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(IncomeViewModel.self) var incomeVM
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(BudgetViewModel.self) var budgetVM
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = userVM.user {
                    VStack {
                        List {
                            Section {
                                NavigationLink(destination: SpendingsListView(user: user)) {
                                    Text("See my spendings")
                                        .foregroundStyle(.primary)
                                        .bold()
                                }
                            }
                            Section {
                                NavigationLink(destination: IncomesListView(user: user)) {
                                    Text("See my incomes")
                                        .foregroundStyle(.primary)
                                        .bold()
                                }
                            }
                            Section {
                                NavigationLink(destination: BudgetsListView(user: user)) {
                                    Text("See my budgets")
                                        .foregroundStyle(.primary)
                                        .bold()
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .task{
                        await spendingVM.loadSpendings(for: user)
                        await categoryVM.loadCategories(user: user)
                        await incomeVM.loadIncomes(user: user)
                        await budgetVM.getCurrentMonthBudgets(user: user)
                    }
                    .navigationTitle(Text("Welcome back \(user.firstName)"))
                    .toolbar{
                        ToolbarItem {
                            NavigationLink(destination: ProfileView(user: user)) {
                                Label("Profile", systemImage: "person.fill")
                            }
                        }
                    }
                }
                
                if let error = userVM.errorMessage {
                    Text(error)
                }
            }
            .task {
                await userVM.loadTestUser()
            }
        }
    }
}


#Preview {
    PreviewContainer{
        MainView()
    }
}
