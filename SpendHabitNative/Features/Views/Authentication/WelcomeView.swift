//
//  WelcomeView.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 4/1/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    // Brand
                    VStack(spacing: 12) {
                        Text("Spend Habit")
                            .font(.system(size: 52, weight: .bold, design: .default))
                            .foregroundStyle(.white)

                        Text("Track your spending.\nBuild better habits.")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    // Actions
                    VStack(spacing: 16) {
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Log in")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)

                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Register")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(true)
    }
}


#Preview {
    PreviewContainer{
        WelcomeView()
    }
}
