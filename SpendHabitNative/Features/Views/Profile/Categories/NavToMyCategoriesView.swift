//
//  NavToMyCategoriesView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 23/12/25.
//

import SwiftUI

struct NavToMyCategoriesView: View {
    let user: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                NavigationLink(destination: MyCategoriesView(user: user)) {
                    HStack{
                        Text("My Categories")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .padding()
                }
            }
            .background(colorScheme == .light ? .white : .gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .padding()
            //.padding(.vertical, 10)
        }
    }
}

#Preview {
    PreviewContainer{
        NavToMyCategoriesView(user: User.mock)
    }
}
