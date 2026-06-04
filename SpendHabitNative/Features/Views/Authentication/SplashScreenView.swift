//
//  SplashScreenView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/2/26.
//

import SwiftUI
import LocalAuthentication

struct SplashScreenView: View {
    @Environment(AppContainers.self) var containers
    @Environment(MethodViewModel.self) var methodVM
    
    var userVM: UserViewModel { containers.userVM}
    @State private var hasStarted = false
    
    @State private var isCheckingLogin = true
    @State private var navigateToMain = false
    @State private var navigateToWelcome = false
    
    @State private var isAuthenticating = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                // Background
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack{
                    Text("Spend Habit")
                        .font(.system(size: 52, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                }
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainView()
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $navigateToWelcome){
                WelcomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
        .task {
            guard !hasStarted else { return }
            hasStarted = true

            guard !isAuthenticating else { return }
            isAuthenticating = true

            await startFlow()
        }
    }
    
    func checkSilentLogin() async {
        
        guard !isAuthenticating else { return }
        isAuthenticating = true
        defer { isAuthenticating = false }
        
        guard let username = KeychainManager.get(key: "username"),
              let password = KeychainManager.get(key: "password")
        else {
            navigateToWelcome = true
            return
        }

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            navigateToWelcome = true
            return
        }

        do {
            let authenticated = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to access your account"
            )
            guard authenticated else {
                navigateToWelcome = true
                return
            }
        } catch {
            navigateToWelcome = true
            return
        }

        userVM.loginUser = UserLogin(username: username, password: password)
        let loginResult = await userVM.login()

        if loginResult == .success {
            await waitForMethods()
            navigateToMain = true
        } else {
            navigateToWelcome = true
        }
    }
    
    func startFlow() async {
        // Always show splash at least 0.25 second
        try? await Task.sleep(nanoseconds: 250_000_000)
        
        await checkSilentLogin()
    }
    
    func waitForMethods() async {
        while methodVM.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        }
    }
}

#Preview {
    PreviewContainer{
        SplashScreenView()
    }
}
