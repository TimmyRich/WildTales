//
//  Landing.swift
//  WildTales
//
//  Created by Kurt McCullough on 24/3/2025.
//

import SwiftUI

struct Landing: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var showSignUp = false
    @State private var showLogIn = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .all)
                    .clipShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("Quokka_1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .padding(.trailing, UIScreen.main.bounds.width-200)
                        .padding(.bottom, 300)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width-130, height: 320)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Pink"), lineWidth: 1)
                        ).shadow(radius: 5)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    Text("Login")
                        .font(Font.custom("Inter", size: 25))
                        .padding(.vertical, 20)
                    
                    TextField("Username/Email", text: $username )
                        .padding(.leading)
                        .font(Font.custom("Inter", size: 15))
                        .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                        .foregroundColor(Color.gray)
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .padding(.leading)
                        .font(Font.custom("Inter", size: 15))
                        .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                        .foregroundColor(Color("Grey"))
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.bottom, 20)
                        .keyboardShortcut(.defaultAction)
                    
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        appState.clickedGo = true
                    }) {
                        Text("Login")
                            .font(Font.custom("Inter", size: 15))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 20)
                    }
                    .frame(width: UIScreen.main.bounds.width-150, height: 30)
                    .background(Color("Pink"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Pink"), lineWidth: 1)
                    )
                    .shadow(radius: 10)
                    .hapticOnTouch()
                    
                    Text("───  Access Quickly  ───")
                        .font(Font.custom("Inter", size: 10))
                        .padding(.vertical, 10)
                    
                    HStack {
                        Button("Google") {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        }
                        .frame(width: UIScreen.main.bounds.width-300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Pink"), lineWidth: 1)
                        )
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                        
                        Button("iCloud") {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        }
                        .frame(width: UIScreen.main.bounds.width-300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Pink"), lineWidth: 1)
                        )
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(Font.custom("Inter", size: 10))
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                        
                        Button("Sign up") {
                            showSignUp.toggle()
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        }
                        .frame(width: 100, height: 30)
                        .background(Color.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom)
                Button("Skip") {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    appState.showIntro = true
                    AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                }
                .frame(width: 100, height: 30)
                .background(Color.white)
                .foregroundColor(Color("Pink"))
                .cornerRadius(10)
                .font(Font.custom("Inter", size: 10))
                .padding(.top, 600)
                .hapticOnTouch()
            }
            .sheet(isPresented: $showSignUp) {
                SignUp()
            }
            .onAppear(){
                AudioManager.startBackgroundMusic()
            }
        }
    }
}

#Preview {
    Landing()
}
