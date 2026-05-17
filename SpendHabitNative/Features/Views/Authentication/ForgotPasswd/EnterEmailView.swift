//
//  EnterEmailView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 09/05/2026.
//

import SwiftUI

struct EnterEmailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppContainers.self) var containers
    var userVM: UserViewModel { containers.userVM }
    @State private var userEmail: String = ""
    @State private var emailSent: Bool = false
    @State private var emailNotValid: Bool = false
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
                Text("Enter your email")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                
                VStack(alignment: .center){
                    TextField("Email", text: Binding(
                        get: { userEmail },
                        set: { userEmail = $0 }
                    ))
                    .keyboardType(.emailAddress)
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
                        let resultCode = await userVM.sendVerificationCode(userEmail: userEmail)
                        
                        isLoading = false
                        
                        if resultCode == 0{
                            emailSent.toggle()
                        }
                        else if resultCode == 1{
                            emailNotValid.toggle()
                        }
                        else if resultCode == 10{
                            apiError.toggle()
                        }
                    }
                }label: {
                    if isLoading {
                        ProgressView()
                            .tint(colorScheme == .light ? .black : .white)
                    } else {
                        Text("Send verification code")
                            .font(Font.headline.bold())
                    }
                }
                .frame(maxWidth: .infinity)
                .controlSize(.large)
                .buttonStyle(.glassProminent)
                .disabled(userEmail.isEmpty || !userEmail.isValidEmail || isLoading)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 38))
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .alert("Invalid email", isPresented: $emailNotValid) {
                Button("Continue") {
                    emailNotValid.toggle()
                }
            } message: {
                Text("\(userVM.errorMessage ?? "Invalid email")")
            }
            .alert("Connection error", isPresented: $apiError) {
                Button("Continue") {
                    apiError.toggle()
                }
            } message: {
                Text("There was an error connecting to the server. Please try again later.")
            }
        }
        .navigationDestination(isPresented: $emailSent){
            NewPasswordView(userEmail: userEmail)
        }
    }
}

#Preview {
    PreviewContainer {
        EnterEmailView()
    }
}
