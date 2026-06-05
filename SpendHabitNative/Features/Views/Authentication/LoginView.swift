//
//  LoginView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 4/1/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoggedIn = false
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    @Environment(AppState.self) var appState
    var userVM: UserViewModel { containers.userVM}
    @State private var showAlert = false
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20){
                Spacer()
                VStack(alignment: .leading, spacing: 16){
                    Text("Log in")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                    
                    
                    VStack(alignment: .center){
                        TextField("Username", text: Binding(
                            get: { userVM.loginUser?.username ?? "" },
                            set: { userVM.loginUser?.username = $0 }
                        ))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    
                    VStack(alignment: .center){
                        HStack{
                            SecureField("Password", text: Binding(
                                get: { userVM.loginUser?.password ?? "" },
                                set: { userVM.loginUser?.password = $0 }
                            ))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        }.padding()
                    }
                    .background(colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .padding(.horizontal, 10)
                    
                    Button {
                        Task {
                            let createResult = await userVM.login()

                            if createResult == .success {
                                await waitForMethods()
                                KeychainManager.save(key: "username", value: userVM.loginUser?.username ?? "")
                                KeychainManager.save(key: "password", value: userVM.loginUser?.password ?? "")
                                // Trigger navigation programmatically
                                await MainActor.run {
                                    appState.isLoggedIn = true
                                }
                            }
                            else if createResult == .invalidInput {
                                showAlert = true
                            }
                        }
                    }label: {
                        Text("Log in")
                            .font(Font.headline.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
                    .buttonStyle(.glassProminent)
                    .disabled(userVM.loginUser?.username.isEmpty ?? false || userVM.loginUser?.password.isEmpty ?? false)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 38))
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                Spacer()
                
                NavigationLink("Forgot password?") {
                    EnterEmailView()
                }
                .frame(maxWidth: .infinity)
                .controlSize(.large)
                .foregroundStyle(.white)
                .bold()
                .buttonStyle(.glassProminent)
            }
        }
        .onAppear {
            userVM.loginUser = UserLogin(username: "", password: "")
        }
        // Modern replacement for the deprecated NavigationLink(isActive:)
        /*.navigationDestination(isPresented: $isLoggedIn) {
            MainView()
                .navigationBarBackButtonHidden(true)
        }*/
        .alert("Incorrect credentials", isPresented: $showAlert) {
            Button("Continue") {
                
            }
        } message: {
            Text("Invalid username or password")
        }
    }
    
    func waitForMethods() async {
        while methodVM.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        }
    }
}

#Preview {
    PreviewContainer{
        LoginView()
    }
}
