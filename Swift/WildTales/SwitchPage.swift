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
    
    init(clickedGo: Bool = false, showIntro: Bool = false) {
        self.clickedGo = clickedGo
        self.showIntro = showIntro
    }
}

@main
struct SwiftUI_DemoApp: App {
    
    @StateObject var appState = AppState(clickedGo: false, showIntro: false)
    
    var body: some Scene {
        WindowGroup {
            if appState.showIntro {
                Intro()
                    .environmentObject(appState)
            } else if appState.clickedGo {
                MapView()
                    .environmentObject(appState)
            } else {
                Landing()
                    .environmentObject(appState)
            }
        }
    }
}
