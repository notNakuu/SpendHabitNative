//
//  SplashScreenView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 22/2/26.
//

import SwiftUI
import LocalAuthentication

struct SplashScreenView: View {
    @Environment(UserViewModel.self) var userVM
    @State private var isCheckingLogin = true
    @State private var navigateToMain = false
    @State private var navigateToWelcome = false
    
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
        .task{
            await startFlow()
        }
    }
    
    func authenticateWithFaceID() async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            do{
                return try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Authenticate to access your account"
                )
            }
            catch{
                return false
            }
        }
        return false
    }
    
    func checkSilentLogin() async {
        
        guard let username = KeychainManager.get(key: "username"),
              let password = KeychainManager.get(key: "password")
        else {
            navigateToWelcome = true
            return
        }
        
        let authenticated = await authenticateWithFaceID()
        
        if authenticated {
            userVM.loginUser = UserLogin(username: username, password: password)
            
            let loginResult = await userVM.login()
            
            if loginResult == .success {
                navigateToMain = true
            }
            else{
                navigateToWelcome = true
            }
        }
    }
    
    func startFlow() async {
        // Always show splash at least 1 second
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await checkSilentLogin()
    }
}

#Preview {
    PreviewContainer{
        SplashScreenView()
    }
}
