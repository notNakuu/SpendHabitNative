//
//  NewIncomeView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import SwiftUI

struct NewIncomeView: View {
    let user: User
    var onAdd: (() -> Void)? = nil
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    var incomeVM: IncomeViewModel { containers.incomeVM }
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationView{
            Form {
                if let _ = incomeVM.newIncome {
                    
                    TextField("Income name", text: Binding(
                        get: { incomeVM.newIncome?.title ?? "" },
                        set: { incomeVM.newIncome?.title = $0 }
                    ))

                    TextField("Amount", value: Binding(
                        get: { incomeVM.newIncome?.amount ?? 0 },
                        set: { incomeVM.newIncome?.amount = $0 }
                    ), format: .number).keyboardType(.decimalPad)
                    
                    Picker("Income Method", selection: Binding(
                        get: { incomeVM.newIncome?.method.id ?? 0 },
                        set: { incomeVM.newIncome?.method.id = $0 }
                        ))
                    {
                        ForEach(methodVM.methods, id: \.id) { method in
                            Label("\(method.name)", systemImage: "\(method.iconKey)")
                                .tag(method.id)
                        }
                    }
                }
            }
            .navigationTitle("New Income")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        isLoading = true
                        Task {
                            await incomeVM.createIncome()
                            if incomeVM.responseCode == 0{
                                onAdd?()
                                dismiss()
                                incomeVM.newIncome = nil
                            }
                        }
                    }
                    label: {
                        if isLoading {
                            ProgressView()
                                .tint(colorScheme == .light ? .black : .white)
                        } else {
                            Text("Add")
                        }
                    }
                    .disabled(incomeVM.newIncome?.title.isEmpty ?? true)
                    .disabled(incomeVM.newIncome?.amount ?? 0 <= 0)
                    .disabled(isLoading)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        incomeVM.newIncome = nil
                    }
                }
            }
        }
        .onAppear {
            if incomeVM.newIncome == nil {
                incomeVM.newIncome = CreateIncomeRequest(
                    user: IdWrapper(id: user.id),
                    title: "",
                    method: IdWrapper(id: methodVM.methods.first!.id),
                    amount: 0
                )
            }
        }
    }
}

#Preview {
    PreviewContainer{
        NewIncomeView(user: User.mock)
    }
}
