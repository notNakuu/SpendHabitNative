//
//  NewSpendingView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import SwiftUI

struct NewSpendingView: View {
    let user: User
    var onAdd: (() -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(MethodViewModel.self) var methodVM
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(BudgetViewModel.self) var budgetVM
    
    var body: some View {
        NavigationView{
            Form {
                if let _ = spendingVM.newSpending {
                    
                    TextField("Spending name", text: Binding(
                        get: { spendingVM.newSpending?.title ?? "" },
                        set: { spendingVM.newSpending?.title = $0 }
                    ))

                    TextField("Amount", value: Binding(
                        get: { spendingVM.newSpending?.amount ?? 0 },
                        set: { spendingVM.newSpending?.amount = $0 }
                    ), format: .number).keyboardType(.decimalPad)
                    
                    Picker("Payment Method", selection: Binding(
                        get: { spendingVM.newSpending?.method.id ?? 0 },
                        set: { spendingVM.newSpending?.method.id = $0 }
                        ))
                    {
                        ForEach(methodVM.methods, id: \.id) { method in
                                //Text(method.name).tag(method.id)
                            Label("\(method.name)", systemImage: "\(method.iconKey)")
                                .tag(method.id)
                        }
                    }
                    
                    Picker("Category", selection: Binding(
                        get: { spendingVM.newSpending?.category.id ?? 0 },
                        set: { spendingVM.newSpending?.category.id = $0 }
                    )) {
                        ForEach(categoryVM.categories.filter { category in
                            if category.isEnabled{
                                return true
                            }
                            return false
                        }, id: \.id) { category in
                            Label("\(category.name)", systemImage: "\(category.iconKey)")
                                .tag(category.id)
                        }
                    }

                    
                }
            }
            .navigationTitle("New Spending")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Add") {
                        Task {
                            await spendingVM.createSpending()
                            if spendingVM.responseCode == 0{
                                onAdd?()
                                dismiss()
                            }
                        }
                    }.disabled(spendingVM.newSpending?.title.isEmpty ?? true)
                        .disabled(spendingVM.newSpending?.amount ?? 0 <= 0)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        spendingVM.newSpending = nil
                    }
                }
            }
        }
        .onAppear {
            if spendingVM.newSpending == nil {
                spendingVM.newSpending = CreateSpendingRequest(
                    user: IdWrapper(id: user.id),
                    title: "",
                    category: IdWrapper(id: categoryVM.categories.first!.id),
                    method: IdWrapper(id: methodVM.methods.first!.id),
                    amount: 0
                )
            }
        }
    }
}


#Preview {
    PreviewContainer{
        NewSpendingView(user: User.mock)
    }
}
