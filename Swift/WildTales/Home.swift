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
                            AudioManager.playSound(soundName: "siren.wav", soundVol: 0.5)
                            showEmergency = true
                        }) {
                            Image(systemName: "phone.connection.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Circle().fill(Color.red))
                                .shadow(radius: 5)
                                .padding()
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                Image("logoTitle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 200)
                
                VStack {
                    HStack {
                        Spacer()
                        VStack{
                            NavigationLink(destination: MapChoice().navigationBarBackButtonHidden(true)) {
                                Image("homeButton2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(TapGesture().onEnded {
                                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            })
                            
                            NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                                Image("homeButton4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(TapGesture().onEnded {
                                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            })
                        }
                        Spacer()
                        
                        VStack{
                            
                            NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                                Image("homeButton1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(TapGesture().onEnded {
                                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            })
                            
                            NavigationLink(destination: Learn().navigationBarBackButtonHidden(true)) {
                                Image("homeButton3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(TapGesture().onEnded {
                                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            })
                            
                        }
                        Spacer()
                    }
                    .padding(.top, 350)
                }
            }
            .overlay(
                Group {
                    if showEmergency {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture { showEmergency = false }
                            
                            Emergency(showEmergency: $showEmergency)
                                .transition(.scale)
                        }
                    }
                }
            )
            .onAppear {
                AudioManager.startBackgroundMusic()
            }
            
        }
    }
}


#Preview{
    Home()
}

