//
//  EditCategoryView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct EditCategoryView: View {
    @State var category: Category
    @State private var showIconPicker = false
    @State private var selectedColor: Color

    let user: User
    
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    init(
            category: Category,
            user: User,
            onAdd: (() -> Void)? = nil
        ) {
            self.category = category
            self.user = user
            self.onAdd = onAdd
            _selectedColor = State(initialValue: Color(hex: category.colorHex))
        }
    
    var onAdd: (() -> Void)? = nil
    
    @State private var showDuplicateAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    TextField("Category name", text: $category.name)
                }

                Section("Appearance") {
                    Button {
                        showIconPicker = true
                    } label: {
                        HStack {
                            Text("Icon")
                            Spacer()
                            Image(systemName: category.iconKey)
                        }
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showIconPicker) {
                        NavigationView {
                            IconPickerView(selectedIcon: $category.iconKey)
                        }
                    }

                    ColorPicker("Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { _, newValue in
                            category.colorHex = newValue.toHex()
                        }


                    
                }
                Section("Preview"){
                    HStack {
                        Text("\(category.name)")
                        Spacer()
                        Image(systemName: category.iconKey)
                            .foregroundStyle(Color(hex: category.colorHex))
                    }
                }

                Section {
                    Toggle("Enabled", isOn: $category.isEnabled)
                }
            }
            .navigationTitle("Edit Category")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // 1. Get the current name safely
                        let currentName = category.name
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        let currentCategoryId = category.id
                        
                        // 2. Perform the duplicate check here
                        let isDuplicate = categoryVM.categories.contains {
                            $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                                .caseInsensitiveCompare(currentName) == .orderedSame && $0.id != currentCategoryId
                        }

                        if isDuplicate {
                            showDuplicateAlert = true
                        } else {
                            Task {
                                await categoryVM.updateCategory(
                                    id: category.id,
                                    name: category.name,
                                    iconKey: category.iconKey,
                                    colorHex: category.colorHex,
                                    isEnabled: category.isEnabled
                                )

                                if categoryVM.responseCode == 0 {
                                    onAdd?()
                                    dismiss()
                                }
                            }
                        }
                    }
                    .disabled(category.name.isEmpty)
                    .alert("Duplicate Category", isPresented: $showDuplicateAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("A category with this name already exists.")
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
        EditCategoryView(category: Category(id: 15, iconKey: "cart.fill", colorHex: "#FF5733", name: "Food", isEnabled: true), user: User.mock)
    }
}
