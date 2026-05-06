//
//  EditSpendingView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 2/1/26.
//

import SwiftUI

struct EditSpendingView: View {
    let user: User
    @State var spending: Spending
    var onAdd: (() -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    @Environment(MethodViewModel.self) var methodVM
    @Environment(AppContainers.self) var containers
    
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var spendingVM: SpendingViewModel { containers.spendingVM }
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("Spending name", text: Binding(
                        get: { spending.title},
                        set: { spending.title = $0 }

                    ))

                    TextField("Amount", value: Binding(
                        get: { spending.amount},
                        set: { spending.amount = $0 }
                    ), format: .number).keyboardType(.decimalPad)
                    
                    Picker("Payment Method", selection: Binding(
                        get: { spending.methodId},
                        set: { spending.methodId = $0 }
                        ))
                    {
                        ForEach(methodVM.methods, id: \.id) { method in
                                //Text(method.name).tag(method.id)
                            Label("\(method.name)", systemImage: "\(method.iconKey)")
                                .tag(method.id)
                        }
                    }
                    
                    Picker("Category", selection: Binding(
                        get: { spending.categoryId},
                        set: { spending.categoryId = $0 }
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
                Section{
                    DatePicker("Date", selection: Binding(
                        get: { spending.createdDate},
                        set: { spending.createdDate = $0 }
                    ),
                    displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Spending")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        Task {
                            await spendingVM.updateSpending(
                                id: spending.id,
                                userId: spending.userId,
                                title: spending.title,
                                categoryId: spending.categoryId,
                                methodId: spending.methodId,
                                createdDate: spending.createdDate,
                                amount: spending.amount
                            )
                            if spendingVM.responseCode == 0{
                                onAdd?()
                                dismiss()
                            }
                        }
                    }
                    .disabled(spending.title.isEmpty)
                        .disabled(spending.amount <= 0)
                        .disabled(spending.createdDate > Date())
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
        EditSpendingView(user: User.mock, spending: Spending.mock)
    }
}
