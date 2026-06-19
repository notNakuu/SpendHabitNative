//
//  AskConfirmDeleteView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 17/06/2026.
//

import SwiftUI

struct AskConfirmDeleteView: View {
    @Environment(AppContainers.self) var containers
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmAlert = false
    @State private var showErrorAlert = false
    
    var userVM: UserViewModel { containers.userVM}
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack{
                Spacer()
                VStack(spacing: 24) {

                    Image(systemName: "exclamationmark.triangle.fill")

                        .font(.system(size: 80))

                        .foregroundStyle(.white)

                    VStack(spacing: 8) {

                        Text("Delete Account")

                            .font(.largeTitle.bold())

                            .foregroundStyle(.white)

                        Text("This action is permanent and cannot be undone.")

                            .font(.headline)

                            .foregroundStyle(.white.opacity(0.9))

                            .multilineTextAlignment(.center)

                    }

                    HStack(spacing: 12){
                        VStack(spacing: 16){
                            Image(systemName: "person.fill")
                            Image(systemName: "creditcard.fill")
                            Image(systemName: "banknote.fill")
                            Image(systemName: "chart.pie.fill")
                            Image(systemName: "folder.fill")
                        }
                        
                        //Divider()
                        VStack(alignment: .leading, spacing: 16){
                            Text("Profile information")
                            Text("Spendings")
                            Text("Income records")
                            Text("Budgets")
                            Text("Categories")
                        }
                    }

                    .font(.headline)

                    .foregroundStyle(.white)

                    .padding()

                    .frame(maxWidth: .infinity, alignment: .leading)

                    .background(.white.opacity(0.15))

                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Text("All associated data stored on our servers will be permanently removed.")

                        .font(.subheadline)

                        .foregroundStyle(.white.opacity(0.85))

                        .multilineTextAlignment(.center)

                }

                .padding(.horizontal, 24)
                Button("Cancel", role: .destructive){
                    dismiss()
                }
                .buttonStyle(.glass)
                Spacer()
                Button("Delete Account", role: .destructive){
                    showConfirmAlert.toggle()
                }
                .font(.headline)
                .buttonStyle(.glassProminent)
            }
            .alert("Account deletion", isPresented: $showConfirmAlert) {
                Button("Continue", role: .destructive) {
                    Task{
                        let result = await userVM.deleteUser()
                        
                        if result == 0 {
                            appState.isLoggedIn = false
                            containers.resetApp()
                        }
                        else{
                            
                        }
                        
                    }
                }
            } message: {
                Text("Your account will be permanently deleted. This action cannot be undone.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("Continue") {

                }
            } message: {
                Text("There was an error while deleting your account. Please try again later.")
            }
        }
    }
}

#Preview {
    PreviewContainer{
        AskConfirmDeleteView()
    }
}
