//
//  TotalByCategoryView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/12/25.
//

import SwiftUI

struct TotalByCategoryView: View {
    @State var user: User
    @Environment(SpendingViewModel.self) var spendingVM
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            Text("Total Spent By Category")
                .font(.headline)
                .padding(.horizontal, 30)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 5)
        
        VStack{
            ForEach(spendingVM.totalSpentByCategory.indices, id: \.self) { index in
                TotalByCategoryRowView(cs: spendingVM.totalSpentByCategory[index])

                if index < spendingVM.totalSpentByCategory.count - 1 {
                    Divider()
                }
            }

        }
        .padding()
        .background(colorScheme == .light ? .white : .gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal)
        .task{
            await spendingVM.loadTotalForEachCategory(for: user)
        }
    }
    
    
}

#Preview {
    PreviewContainer{
        TotalByCategoryView(user: User.mock)
    }
}
