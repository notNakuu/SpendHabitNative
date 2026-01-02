//
//  NewCategoryView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 25/12/25.
//

import SwiftUI

struct NewCategoryView: View {
    @State private var showIconPicker = false
    @State private var selectedColor: Color
    
    let user: User
    var onAdd: (() -> Void)? = nil
    
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    init(user: User, onAdd: (() -> Void)? = nil) {
        self.user = user
        self.onAdd = onAdd
        
        // Initialize color from newCategory if available, else default
        let initialHex = "#000000"
        _selectedColor = State(initialValue: Color(hex: initialHex))
    }
    
    @State private var showDuplicateAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // General section
                Section("General") {
                    TextField(
                        "Category name",
                        text: Binding(
                            get: { categoryVM.newCategory?.name ?? "" },
                            set: { categoryVM.newCategory?.name = $0 }
                        )
                    )
                }
                
                // Appearance section
                Section("Appearance") {
                    Button {
                        showIconPicker = true
                    } label: {
                        HStack {
                            Text("Icon")
                            Spacer()
                            Image(systemName: categoryVM.newCategory?.iconKey ?? "questionmark")
                        }
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showIconPicker) {
                        NavigationView {
                            IconPickerView(
                                selectedIcon: Binding(
                                    get: { categoryVM.newCategory?.iconKey ?? "questionmark" },
                                    set: { categoryVM.newCategory?.iconKey = $0 }
                                )
                            )
                        }
                    }
                    
                    ColorPicker("Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { _, newValue in
                            categoryVM.newCategory?.colorHex = newValue.toHex()
                        }
                }
                
                // Preview section
                Section("Preview") {
                    HStack {
                        Text("\(categoryVM.newCategory?.name ?? "Preview")")
                        Spacer()
                        Image(systemName: categoryVM.newCategory?.iconKey ?? "questionmark")
                            .foregroundStyle(Color(hex: categoryVM.newCategory?.colorHex ?? "#000000"))
                    }
                }
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        // 1. Get the current name safely
                        let currentName = categoryVM.newCategory?.name
                            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                        
                        // 2. Perform the duplicate check here
                        let isDuplicate = categoryVM.categories.contains {
                            $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                                .caseInsensitiveCompare(currentName) == .orderedSame
                        }

                        if isDuplicate {
                            showDuplicateAlert = true
                        } else {
                            Task {
                                await categoryVM.createCategory()
                                if categoryVM.responseCode == 0 {
                                    onAdd?()
                                    dismiss()
                                }
                            }
                        }
                    }
                    .disabled(categoryVM.newCategory?.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
                    .alert("Duplicate Category", isPresented: $showDuplicateAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("A category with this name already exists. Consider re-enabling it if it’s disabled.")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        categoryVM.newCategory = nil
                    }
                }
            }
        }
        .onAppear {
            if categoryVM.newCategory == nil {
                categoryVM.newCategory = CreateCategoryRequest(
                    name: "",
                    user: IdWrapper(id: user.id),
                    iconKey: "questionmark",
                    colorHex: "#000000"
                )
            }
        }
    }
}

#Preview {
    PreviewContainer {
        NewCategoryView(user: User.mock)
    }
}

