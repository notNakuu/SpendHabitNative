//
//  EditIncomeView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 20/1/26.
//

import SwiftUI

struct EditIncomeView: View {
    let user: User
    @State var income: Income
    var onAdd: (() -> Void)? = nil
    
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    var categoryVM: CategoryViewModel { containers.categoryVM }
    var incomeVM: IncomeViewModel { containers.incomeVM }
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("Income name", text: Binding(
                        get: { income.title },
                        set: { income.title = $0 }
                    ))

                    TextField("Amount", value: Binding(
                        get: { income.amount },
                        set: { income.amount = $0 }
                    ), format: .number).keyboardType(.decimalPad)
                    
                    Picker("Income Method", selection: Binding(
                        get: { income.methodId},
                        set: { income.methodId = $0 }
                        ))
                    {
                        ForEach(methodVM.methods, id: \.id) { method in
                            Label("\(method.name)", systemImage: "\(method.iconKey)")
                                .tag(method.id)
                        }
                    }
                }
                Section{
                    DatePicker("Date", selection: Binding(
                        get: { income.createdDate},
                        set: { income.createdDate = $0 }
                    ),
                    displayedComponents: .date)
                }
            }
            .navigationTitle("Edit income")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        Task {
                            await incomeVM.updateIncome(
                                id: income.id,
                                userId: income.userId,
                                title: income.title,
                                methodId: income.methodId,
                                createdDate: income.createdDate,
                                amount: income.amount)
                            
                            
                            if incomeVM.responseCode == 0{
                                onAdd?()
                                dismiss()
                            }
                        }
                    }.disabled(income.title.isEmpty)
                        .disabled(income.amount <= 0)
                        .disabled(income.createdDate > Date())
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
        EditIncomeView(user: User.mock, income: Income.mock)
    }
}
