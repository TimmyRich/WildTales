//
//  Home.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var showSignUp = false
    @State private var showLogIn = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("home")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .all)
                    .clipShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack{
                        Spacer()
                        Image("Quokka_2")
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/4)
                            .ignoresSafeArea(.all)
                        
                    }
                    Spacer()
                }
                
                Image("logoTitle")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 200)
                
                VStack{

                    HStack{
                        
                        
                        Button(action: {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)

                                }) {
                                    Image("homeButton2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.horizontal)
                                        .hapticOnTouch()
                                }
                        
                        Button(action: {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)

                                }) {
                                    Image("homeButton1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.horizontal)
                                        .padding(.top, 200)
                                        .hapticOnTouch()
                                }
                        
                        Button(action: {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                                }) {
                                    Image("homeButton3")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .padding(.horizontal)
                                        .hapticOnTouch()
                                }
                        
                    }.padding(.top, 300)

                }
                
                
                
                

                
                
            }
            .onAppear(){
                AudioManager.startBackgroundMusic()
            }
        }
    }
}

#Preview {
    Home()
}

