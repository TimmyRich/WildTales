//
//  Landing.swift
//  WildTales
//
//  Created by Kurt McCullough on 24/3/2025.
//
// This page shows up when the user first opens the app on their iPhone.
// They can log in (simulated) or click sign up to open a new sheet to create an account.
// Presssing sign up, login or skip all goes to the intro dequence
//
//
//

import SwiftUI

struct Landing: View {

    @EnvironmentObject var appState: AppState

    @State private var username: String = ""  //keep it empty
    @State private var password: String = ""

    @State private var showSignUp = false  // states to show intro
    @State private var showLogIn = false

    var body: some View {

        NavigationView {  // allows for easyily changable views from one to another

            //ZStack allows for layes on top of one another
            ZStack {
                // First image that takes up whole screen
                Image("Background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .all)
                    .clipShape(Rectangle())
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                VStack {
                    Spacer()

                    Image("Quokka_1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .padding(.trailing, UIScreen.main.bounds.width - 200)
                        .padding(.bottom, 300)

                    Spacer()
                }

                VStack {
                    Spacer()

                    Rectangle()
                        .frame(
                            width: UIScreen.main.bounds.width - 130,
                            height: 320
                        )
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

                    TextField("Username/Email", text: $username)  // doesnt hole text
                        .padding(.leading)
                        .font(Font.custom("Inter", size: 15))
                        .frame(
                            width: UIScreen.main.bounds.width - 150,
                            height: 30
                        )
                        .foregroundColor(Color.gray)
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Password", text: $password)  //also doesnt hole text but will encrypt it in SecureField
                        .padding(.leading)
                        .font(Font.custom("Inter", size: 15))
                        .frame(
                            width: UIScreen.main.bounds.width - 150,
                            height: 30
                        )
                        .foregroundColor(Color("Grey"))
                        .background(Color("LightGrey"))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.bottom, 20)
                        .keyboardShortcut(.defaultAction)

                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        appState.clickedGo = true  // change views to show intro
                    }) {
                        Text("Login")
                            .font(Font.custom("Inter", size: 15))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 20)
                    }
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .background(Color("Pink"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Pink"), lineWidth: 1)
                    )
                    .shadow(radius: 10)
                    .hapticOnTouch()  //haptic press

                    Text("───  Access Quickly  ───")
                        .font(Font.custom("Inter", size: 10))
                        .padding(.vertical, 10)

                    HStack {
                        Button("Google") {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }
                        .frame(
                            width: UIScreen.main.bounds.width - 300,
                            height: 20
                        )
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
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }
                        .frame(
                            width: UIScreen.main.bounds.width - 300,
                            height: 20
                        )
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
                            showSignUp.toggle()  // shows the sign up sheet
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
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
                    appState.showIntro = true  // goes to intro sequence
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
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
                SignUp()  // when showSignUp is true
            }
            .onAppear {
                AudioManager.startBackgroundMusic()  // starts background music
            }
        }
    }
}

#Preview {
    Landing()
}
