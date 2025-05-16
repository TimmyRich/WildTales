//
//  SwiftUI_DemoApp.swift
//  SwiftUI Demo
//
//  Created by Kurt McCullough on 24/3/2025.
//
// This page takes some variables and determins which view should be shown based upon those
// A better method of NavigationView was found to switch pages and views so this is only used for the intro sequence and logging in / signing up
//
//

import SwiftUI

class AppState: ObservableObject {
    @Published var clickedGo: Bool
    @Published var showIntro: Bool
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn") //stores if logged in on the iPhone, can remember this when closing the app
        }
    }

    init() {
        self.clickedGo = false
        self.showIntro = false
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") //stores again
        // Set up notification
        NotificationManager.setupNotifications()
    }
}

@main
struct WildTales: App {
    // app states to help switch page, this was replaced with Navigation View later i the developpment

    @StateObject var appState = AppState()
    @StateObject var popupManager = PopupManager()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                Home()
                    .environmentObject(appState)
                    .environmentObject(popupManager)
            } else if appState.showIntro {
                Intro()
                    .environmentObject(appState)
            } else if appState.clickedGo {
                Home()
                    .environmentObject(appState)
                    .environmentObject(popupManager)
            } else {
                Landing()
                    .environmentObject(appState)
            }
        }
    }
}
