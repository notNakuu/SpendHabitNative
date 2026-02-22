//
//  RegisterView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 4/1/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(\.colorScheme) var colorScheme
    @State private var confirmPassword = ""
    @State private var usernameTaken = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessAlert = false

    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                // Background
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16){
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Create an account")
                            .font(.largeTitle.bold())

                        Text("It only takes a minute")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.white)
                    
                    VStack(alignment: .center){
                        TextField("Username", text: Binding(
                            get: { userVM.newUser?.username ?? "" },
                            set: { userVM.newUser?.username = $0 }
                        ))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    if usernameTaken {
                        Text("Username already taken")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .center){
                        TextField("Email", text: Binding(
                            get: { userVM.newUser?.email ?? "" },
                            set: { userVM.newUser?.email = $0 }
                        ))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    Divider()
                        .frame(height: 24)

                    
                    VStack(alignment: .center){
                        HStack{
                            TextField("First name", text: Binding(
                                get: { userVM.newUser?.firstName ?? "" },
                                set: { userVM.newUser?.firstName = $0 }
                            ))
                            
                            TextField("Last name", text: Binding(
                                get: { userVM.newUser?.lastName ?? "" },
                                set: { userVM.newUser?.lastName = $0 }
                            ))
                        }.padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    Divider()
                        .frame(height: 24)

                    
                    VStack(alignment: .center){
                        HStack{
                            SecureField("Password", text: Binding(
                                get: { userVM.newUser?.password ?? "" },
                                set: { userVM.newUser?.password = $0 }
                            ))
                            .textInputAutocapitalization(.never)
                        }.padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    VStack(alignment: .center){
                        HStack{
                            SecureField("Confirm password", text: Binding(
                                get: { confirmPassword },
                                set: { confirmPassword = $0 }
                            ))
                            .foregroundStyle(checkPasswds() || confirmPassword.isEmpty ? .primary : Color(.red))
                            .textInputAutocapitalization(.never)
                        }.padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    Button {
                        Task {
                            let usernameResult = await userVM.checkUsername()

                            guard usernameResult == .success else {
                                usernameTaken = (usernameResult == .invalidInput)
                                return
                            }

                            let createResult = await userVM.createUser()

                            if createResult == .success {
                                showSuccessAlert = true
                            }
                        }
                    }label: {
                        Text("Sign up")
                            .font(Font.headline.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
                    .buttonStyle(.glassProminent)
                    .padding(.top, 12)
                    .disabled(checkFields())
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .onAppear {
                userVM.newUser = UserCreate(username: "", email: "", firstName: "", lastName: "", password: "")
            }
        }
        .alert("Account created", isPresented: $showSuccessAlert) {
            Button("Continue") {
                dismiss()
            }
        } message: {
            Text("Your account was created successfully. You can now log in.")
        }

    }
    
    
    func checkPasswds() -> Bool{
        if userVM.newUser?.password != confirmPassword {
            return false
        }
        return true
    }
    
    func checkFields() -> Bool{
        if userVM.newUser?.username.isEmpty == true || userVM.newUser?.email.isEmpty == true || userVM.newUser?.firstName.isEmpty == true || userVM.newUser?.lastName.isEmpty == true || userVM.newUser?.password.isEmpty == true {
            return true
        }
        
        if userVM.newUser?.password != confirmPassword {
            return true
        }
        
        return false
    }
}

#Preview {
    PreviewContainer{
        RegisterView()
    }
}
