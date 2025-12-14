//
//  UpdateBudgetView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import SwiftUI

struct UpdateBudgetView: View {
    @State var budget: Budget
    @State var user: User
    @State private var stepAmount: Double = 10
    @Environment(BudgetViewModel.self) var budgetVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.dismiss) var dismiss
    
    var onAdd: (() -> Void)? = nil
    
    var category: Category? {
        categoryVM.categories.first { $0.id == budget.categoryId }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // Current budget
                Text("\(budget.amount, specifier: "%.2f")€")
                    .font(.largeTitle)
                    .bold()
                
                // Step amount
                Text("Step: \(stepAmount, specifier: "%.2f")€")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        budget.amount -= stepAmount
                    }) {
                        Text("-")
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(.red.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        budget.amount += stepAmount
                    }) {
                        Text("+")
                            .font(.title)
                            .foregroundStyle(.primary)
                            .frame(width: 60, height: 60)
                            .background(.green.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(category?.name ?? "Unknown")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        Task{
                            await budgetVM.updateBudget(budget: budget, user: user)
                            
                            if budgetVM.resultCode == 0 {
                                onAdd?()
                                dismiss()
                            }
                            
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    PreviewContainer{
        UpdateBudgetView(budget: Budget.mock, user: User.mock)
    }
}
