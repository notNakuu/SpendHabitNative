//
//  UserInfoView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 06/04/2026.
//

import SwiftUI

struct UserInfoView: View {
    @State var user: User
    @Environment(AppContainers.self) var containers
    var userVM: UserViewModel { containers.userVM }
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Profile Header
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                    
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.title2.bold())

                    Text("Member since \(user.registeredDate.formatted(date: .abbreviated, time: .omitted))")
                        .foregroundStyle(.secondary)
                }

                // Personal Information
                VStack(alignment: .leading, spacing: 16) {

                    Text("Personal Information")
                        .font(.headline)

                    CustomField(
                        title: "First Name",
                        text: Binding(
                            get: { user.firstName },
                            set: { user.firstName = $0 }
                        )
                    )

                    CustomField(
                        title: "Last Name",
                        text: Binding(
                            get: { user.lastName },
                            set: { user.lastName = $0 }
                        )
                    )

                    CustomField(
                        title: "Username",
                        text: Binding(
                            get: { user.username },
                            set: { user.username = $0 }
                        )
                    )
                    
                    CustomField(
                        title: "Email",
                        text: Binding(
                            get: { user.email},
                            set: { user.email = $0 }
                    ))
                }
                .padding()
                .background(cardBackground)

                Button {
                    Task {
                        let code = await userVM.updateUserData(user: user)

                        switch code {
                        case 0:
                            alertMessage = "User updated successfully"
                            isSuccess = true

                        case 1:
                            alertMessage = "UserId or data cannot be null"
                            isSuccess = false

                        case 2:
                            alertMessage = "User not found"
                            isSuccess = false

                        case 3:
                            alertMessage = "Username already in use"
                            isSuccess = false

                        default:
                            alertMessage = "Unexpected error occurred"
                            isSuccess = false
                        }

                        showAlert = true
                    }
                } label: {
                    Text("Save Changes")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(user.username.isEmpty || user.firstName.isEmpty || user.lastName.isEmpty || user.email.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            colorScheme == .light
            ? Color(.systemGroupedBackground)
            : Color.black
        )
        .alert(alertMessage, isPresented: $showAlert) {
            if isSuccess {
                Button("OK") {
                    //containers.userVM.user = user // optional sync if needed
                    dismiss()
                }
            } else {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color(.secondarySystemBackground))
    }
}

#Preview {
    PreviewContainer{
        UserInfoView(user: User.mock)
    }
}
