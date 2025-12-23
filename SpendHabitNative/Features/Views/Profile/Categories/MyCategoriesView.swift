//
//  MyCategoriesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct MyCategoriesView: View {
    @State var user: User
    @Environment(CategoryViewModel.self) var categoryVM
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            List{
                Text("Yea")
            }
            .navigationTitle("My Categories")
        }
    }
}

#Preview {
    PreviewContainer {
        MyCategoriesView(user: User.mock)
    }
}
