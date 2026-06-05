//
//  SpendHabitNativeApp.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import SwiftUI

@main
struct SpendHabitNativeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("lastActiveTimestamp")
    private var lastActiveTimestamp: Double = 0
    @State var reloadID = UUID()

    @State var methodVM = MethodViewModel()
    @State var appContainers = AppContainers()
    
    @State var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.isLoggedIn {
                    SplashScreenView()
                        .id(reloadID)
                }
                else {
                    MainView()
                }
            }
            .task {
                await methodVM.loadMethods()
            }
        }
        .environment(methodVM)
        .environment(appContainers)
        .environment(appState)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                    lastActiveTimestamp = Date().timeIntervalSince1970
            case .active:
                let now = Date().timeIntervalSince1970

                if lastActiveTimestamp != 0 {
                    let elapsed = now - lastActiveTimestamp

                    if elapsed > 10 * 60 {
                        resetView()
                    }
                }

                lastActiveTimestamp = now

            default:
                break
            }
        }
    }
    
    func resetView(){
        reloadID = UUID()
        appContainers.resetApp()
        appState.isLoggedIn = false

    }
}
