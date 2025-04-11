//
//  SwiftUI_DemoApp.swift
//  SwiftUI Demo
//
//  Created by Kurt McCullough on 24/3/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var clickedGo: Bool
    @Published var showIntro: Bool
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn") 
        }
    }
    
    init() {
        self.clickedGo = false
        self.showIntro = false
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        // Set up notification
        NotificationManager.setupNotifications()
    }
}


@main
struct WildTales: App {
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                Home()
                    .environmentObject(appState)
            } else if appState.showIntro {
                Intro()
                    .environmentObject(appState)
            } else if appState.clickedGo {
                Home()
                    .environmentObject(appState)
            } else {
                Landing()
                    .environmentObject(appState)
            }
        }
    }
}
