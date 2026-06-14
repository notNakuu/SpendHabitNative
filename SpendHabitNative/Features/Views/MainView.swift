//
//  MainView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import SwiftUI
import Observation

struct MainView: View {
    @State private var isContentReady = false
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    
    var userVM: UserViewModel { containers.userVM}
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var incomeVM: IncomeViewModel { containers.incomeVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    var budgetVM: BudgetViewModel { containers.budgetVM }
    
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: HomeTab = .spendings
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                proxy in let height = proxy.size.height
                ZStack(alignment: .top) {
                    topHeader .frame(height: height * 0.25)
                    
                    // 🟦 CARD INFERIOR
                    Group {
                        if isContentReady {
                            bottomCard(height: height)
                                .transition(
                                    .move(edge: .bottom)
                                    .combined(with: .opacity)
                                )
                        }
                        else {
                            bottomCard(height: height)
                                .hidden()
                        }
                    }
                    .padding(.top, height * 0.17)
                }
                .background(colorScheme == .light
                            ? Color(.secondarySystemBackground)
                            : Color(.systemBackground))
                .ignoresSafeArea(edges: [.top, .bottom])
            }
        }
        .navigationBarBackButtonHidden(true)
        .task(id: userVM.user?.id){
            guard let user = userVM.user else { return }
            
            async let spendings: () = spendingVM.loadSpendings(for: user)
            async let categories: () = categoryVM.loadCategories(user: user)
            async let incomes: () = incomeVM.loadIncomes(user: user)
            async let budgets: () = budgetVM.getCurrentMonthBudgets(user: user)
            
            _ = await (spendings, categories, incomes, budgets)
            
            try? await Task.sleep(for: .milliseconds(100))
            
            await MainActor.run{
                isContentReady = true
            }
        }
        .animation(.easeOut(duration: 0.25), value: isContentReady)
        
    }
        
    
    private var topHeader: some View {
        VStack{
            if userVM.user != nil {
                HStack(alignment: .top) {
                    Text(selectedTab.title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    NavigationLink{
                        ProfileView()
                    }label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 80)
                
                Spacer()
            }
        }
        .background(Color(.blue))
    }
    
    private func bottomCard(height: CGFloat) -> some View {
        VStack(spacing: 12) {

            tabIndicator

            if let user = userVM.user {
                TabView(selection: $selectedTab) {
                    IncomesHomeView(user: user)
                        .tag(HomeTab.incomes)

                    SpendingsHomeView(user: user)
                        .tag(HomeTab.spendings)

                    BudgetHomeView(user: user)
                        .tag(HomeTab.budgets)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: height * 0.86)
            }
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .fill(colorScheme == .light
                      ? Color(.secondarySystemBackground)
                      : Color(.systemBackground))
        )
    }

    
    private var tabIndicator: some View {
        HStack(spacing: 12) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                Text(tab.title)
                    .font(.caption2)
                    .bold()
                    .foregroundStyle( selectedTab == tab ? .white : .primary )
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
