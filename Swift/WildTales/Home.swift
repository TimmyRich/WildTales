//
//  Home.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//


import SwiftUI

struct Home: View {
    @EnvironmentObject var appState: AppState
    
    @State private var showEmergency = false
    
    var hasSeenScrapBookGuide: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenScrapBookGuide")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("home")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Image("Quokka_2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 4)
                            .ignoresSafeArea(.all)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            showEmergency = true
                        }) {
                            Image(systemName: "phone.connection.fill")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                Image("logoTitle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 200)
                
                VStack {
                    HStack {
                        NavigationLink(destination: MapView().navigationBarBackButtonHidden(true)) {
                            Image("homeButton2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                        }
                        
                        Group {
                            if hasSeenScrapBookGuide {
                                NavigationLink(destination: ScrapBook()) {
                                    Image("homeButton1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.top, 150)
                                }
                            } else {
                                NavigationLink(destination: ScrapBookGuide()) {
                                    Image("homeButton1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.top, 150)
                                }
                            }
                        }
                        
                        NavigationLink(destination: Intro()) {
                            Image("homeButton3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                        }
                    }
                    .padding(.top, 300)
                }
                
                if showEmergency {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture { showEmergency = false }
                        
                        Emergency(showEmergency: $showEmergency)
                            //.transition(.scale)
                    }
                }
            }
            .onAppear {
                AudioManager.startBackgroundMusic()
            }
        }
    }
}


#Preview{
    Home()
}
