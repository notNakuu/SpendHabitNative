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
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedTab: HomeTab = .spendings
    
    var body: some View {
        NavigationStack {
            if let user = userVM.user {
                GeometryReader { proxy in
                    let height = proxy.size.height
                    ZStack(alignment: .top) {

                        topHeader
                            .frame(height: height * 0.25)

                        bottomCard
                            .padding(.top, height * 0.20)

                    }

                    .ignoresSafeArea(edges: .top)
                    .ignoresSafeArea(edges: .bottom)
                    .task{
                        await spendingVM.loadSpendings(for: user)
                        await categoryVM.loadCategories(user: user)
                        await incomeVM.loadIncomes(user: user)
                        await budgetVM.getCurrentMonthBudgets(user: user)
                    }
                }
                
            }
            else{
                Text("\(userVM.errorMessage ?? "No error message but something went wrong")")
            }
        }
        .task {
            await userVM.loadTestUser()
        }
    }
    
    private var topHeader: some View {
        VStack{
            if let user = userVM.user {
                HStack(alignment: .top) {
                    Text(selectedTab.title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Spacer()

                    NavigationLink{
                        ProfileView(user: user)
                    }label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 90)

                    Spacer()
            }
        }
        .background(Color(.blue).opacity(0.8))
    }


    private var bottomCard: some View {
        VStack(spacing: 12) {

            // 🧊 Glassy tab indicator
            tabIndicator

            // 📄 Paged content
            if let user = userVM.user {
                TabView(selection: $selectedTab) {

                    IncomesHomeView(user: user)
                        .tag(HomeTab.incomes)

                    SpendingsHomeView(user: user)
                        .tag(HomeTab.spendings)

                    BudgetHomeView(user: user)
                        .tag(HomeTab.budgets)
                }
                .ignoresSafeArea(edges: .all)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
            }
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(colorScheme == .light ? Color(.secondarySystemBackground) : Color(.systemBackground))
        )
    }


    private var tabIndicator: some View {
        HStack(spacing: 12) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                Text(tab.title)
                    .font(.caption2)
                    .bold()
                    .foregroundStyle(
                        selectedTab == tab ? .white : .primary
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(Color(.blue))
                        }
                    }
            }
        }
        .animation(.easeInOut, value: selectedTab)
    }
}


#Preview {
    PreviewContainer{
        MainView()
    }
}
