//
//  MyCategoriesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct MyCategoriesView: View {
    let user: User
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedCategory: Category? = nil
    @State private var showCreateCategory = false

    var body: some View {
        NavigationStack {
            List {
                Section{
                    ForEach(categoryVM.categories.filter { $0.isEnabled }, id: \.id) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            let color = Color(hex: category.colorHex)

                            HStack {
                                Image(systemName: category.iconKey)
                                    .font(.system(size: 18))
                                    .frame(width: 32, height: 32)
                                    .background(color.opacity(0.2))
                                    .clipShape(Circle())
                                    .foregroundColor(color)

                                Text(category.name)
                                    .font(.headline)
                                    .foregroundStyle(category.isEnabled ? .primary : .secondary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    // Add Category
                    Button {
                        showCreateCategory = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 18))
                                .frame(width: 32, height: 32)
                                .background(Color.accentColor.opacity(0.15))
                                .clipShape(Circle())
                                .foregroundColor(.accentColor)

                            Text("Add Category")
                                .font(.headline)
                        }
                    }
                }
                
                
                Section("Disabled"){
                    ForEach(categoryVM.categories.filter { !$0.isEnabled }, id: \.id) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            let color = Color(hex: category.colorHex)

                            HStack {
                                Image(systemName: category.iconKey)
                                    .font(.system(size: 18))
                                    .frame(width: 32, height: 32)
                                    .background(color.opacity(0.2))
                                    .clipShape(Circle())
                                    .foregroundColor(color)

                                Text(category.name)
                                    .font(.headline)
                                    .foregroundStyle(category.isEnabled ? .primary : .secondary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("My Categories")
        }

        // EDIT CATEGORY SHEET
        .sheet(item: $selectedCategory) { category in
            EditCategoryView(category: category, user: user){
                Task{
                    await categoryVM.loadCategories(user: user)
                }
            }
                .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
                .presentationDetents([.fraction(0.75)])
        }

        // CREATE CATEGORY SHEET (future)
        .sheet(isPresented: $showCreateCategory) {
            NewCategoryView(user: user){
                Task{
                    await categoryVM.loadCategories(user: user)
                }
            }
                .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.8))
                .presentationDetents([.fraction(0.65)])
        }
    }
}


#Preview {
    PreviewContainer {
        MyCategoriesView(user: User.mock)
    }
}
