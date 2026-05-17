//
//  NewPasswordView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 13/05/2026.
//

import SwiftUI

struct NewPasswordView: View {
    let userEmail: String
    
    @State private var token: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordConfirmation: String = ""
    
    @State private var navigateToWelcome: Bool = false
    
    @State private var success: Bool = false
    @State private var serverError: Bool = false
    @State private var userError: Bool = false
    @State private var passwordsError: Bool = false
    @State private var tokenExpired: Bool = false
    @State private var unexpectedError: Bool = false
    
    var passwordsMatch: Bool { newPassword == newPasswordConfirmation }
    var passwordsNotEmpty: Bool {
        !newPassword.isEmpty && !newPasswordConfirmation.isEmpty
    }
    var tokenValid: Bool {
        token.count == 6
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    var userVM: UserViewModel { containers.userVM }
    
    @State private var apiError: Bool = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16){
                Text("Create new password")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)

                VStack(alignment: .center){
                    TextField("Confirmation code", text: Binding(
                        get: { token },
                        set: { token = $0 }
                    ))
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .padding()
                }
                .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(.horizontal, 10)
                
                Divider()
                VStack(alignment: .center){
                    SecureField("New password", text: Binding(
                        get: { newPassword },
                        set: { newPassword = $0 }
                    ))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                }
                .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(.horizontal, 10)
                
                VStack(alignment: .center){
                    SecureField("Confirm new password", text: Binding(
                        get: { newPasswordConfirmation },
                        set: { newPasswordConfirmation = $0 }
                    ))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                }
                .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(.horizontal, 10)
                
                
                Button {
                    isLoading = true
                    Task{
                        let resultCode = await userVM.resetPassword(userEmail: userEmail, token: token, newPassword: newPassword)
                        
                        isLoading = false
                        
                        switch resultCode{
                        case 0:
                            success.toggle()
                        case 1:
                            serverError.toggle()
                        case 2:
                            userError.toggle()
                        case 3:
                            passwordsError.toggle()
                        case 4:
                            tokenExpired.toggle()
                        default:
                            print("\(userVM.errorMessage ?? "No message")")
                            unexpectedError.toggle()
                        }
                    
                        
                    }
                }label: {
                    if isLoading {
                        ProgressView()
                            .tint(colorScheme == .light ? .black : .white)
                    } else {
                        Text("Reset password")
                            .font(Font.headline.bold())
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .controlSize(.large)
                .buttonStyle(.glassProminent)
                .disabled(
                    !tokenValid ||
                    !passwordsNotEmpty ||
                    !passwordsMatch ||
                    isLoading
                )
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 38))
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .alert("Password reset success", isPresented: $success) {
                Button("Continue") {
                    navigateToWelcome.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Your password has been reset successfully. You can now log in.")")
            }
            .alert("Server Error", isPresented: $serverError) {
                Button("Continue") {
                    serverError.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Please try again later")")
            }
            .alert("User Error", isPresented: $userError) {
                Button("Continue") {
                    userError.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Please try again later")")
            }
            .alert("Passwords don't match", isPresented: $passwordsError) {
                Button("Continue") {
                    passwordsError.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Please try again later")")
            }
            .alert("Verification code expired", isPresented: $tokenExpired) {
                Button("Continue") {
                    tokenExpired.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Please try again later")")
            }
            .alert("Unexpected error", isPresented: $unexpectedError) {
                Button("Continue") {
                    unexpectedError.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Please try again later")")
            }
        }
        .navigationDestination(isPresented: $navigateToWelcome){
            WelcomeView()
        }
    }
}

#Preview {
    PreviewContainer{
        NewPasswordView(userEmail: "notnakuusemail@gmail.com")
    }
}
