//
//  Landing.swift
//  SwiftUI Demo
//
//  Created by Kurt McCullough on 24/3/2025.
//
// Very simmilar to Landing, contains different text and some extra fields to fill out if the user was signing up

import AVFoundation
import CoreHaptics
import SpriteKit
import SwiftUI

struct SignUp: View {

    @EnvironmentObject var appState: AppState
    @State var player: AVAudioPlayer?
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var name: String = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {

        ZStack {
            Image("Background1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)

            VStack {
                Spacer()

                Image("Quokka_1")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .padding(.trailing, UIScreen.main.bounds.width - 200)
                    .padding(.bottom, 330)

                Spacer()

            }

            VStack {
                Spacer()

                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 130, height: 340)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .preferredColorScheme(.light)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("HunterGreen"), lineWidth: 1)
                    ).shadow(radius: 5)

                Spacer()

            }

            VStack {

                Spacer()
                Text("Sign Up")
                    .font(Font.custom("Inter", size: 25))
                    .padding(.vertical, 20)
                    .preferredColorScheme(.light)

                TextField("Name", text: $name)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background( /*@START_MENU_TOKEN@*/
                        /*@PLACEHOLDER=View@*/Color(
                            "LightGrey"
                        ) /*@END_MENU_TOKEN@*/
                    )
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .preferredColorScheme(.light)

                TextField("Username/Email", text: $username)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background( /*@START_MENU_TOKEN@*/
                        /*@PLACEHOLDER=View@*/Color(
                            "LightGrey"
                        ) /*@END_MENU_TOKEN@*/
                    )
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .preferredColorScheme(.light)

                SecureField("Password", text: $password)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background( /*@START_MENU_TOKEN@*/
                        /*@PLACEHOLDER=View@*/Color(
                            "LightGrey"
                        ) /*@END_MENU_TOKEN@*/
                    )
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 20)
                    .preferredColorScheme(.light)

                Button("Login") {
                    appState.showIntro = true
                    playSound(soundName: "boing.wav", soundVol: 0.5)
                }.frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .background( /*@START_MENU_TOKEN@*/
                        /*@PLACEHOLDER=View@*/Color(
                            "HunterGreen"
                        ) /*@END_MENU_TOKEN@*/
                    )
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("HunterGreen"), lineWidth: 1)
                    ).shadow(radius: 10)
                    .font(Font.custom("Inter", size: 15))
                    .preferredColorScheme(.light)
                    .hapticOnTouch()

                Text("───  Access Quickly  ───")
                    .font(Font.custom("Inter", size: 10))
                    .padding(.vertical, 10)
                    .preferredColorScheme(.light)

                HStack {
                    Button("Google") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)

                    }.frame(width: UIScreen.main.bounds.width - 300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("HunterGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("HunterGreen"), lineWidth: 1)
                        )
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                        .preferredColorScheme(.light)

                    Button("iCloud") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)

                    }.frame(width: UIScreen.main.bounds.width - 300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("HunterGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("HunterGreen"), lineWidth: 1)
                        )
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                        .preferredColorScheme(.light)

                }

                HStack {

                    Text("Already have an account?")
                        .font(Font.custom("Inter", size: 10))
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                        .preferredColorScheme(.light)

                    Button("Log In") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)
                        dismiss()

                    }.frame(width: 50, height: 20)
                        .background(.white)
                        .foregroundColor(Color("HunterGreen"))
                        .cornerRadius(10)

                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                        .preferredColorScheme(.light)

                }
                Spacer()
            }.padding(.bottom)
        }
    }

    // Function to play sounds with a file name and a sound level
    // This code was inspired by https://www.hackingwithswift.com/forums/100-days-of-swiftui/trying-to-play-sound-when-pressing-button/28226
    // It was changed according to app needs like different file types
    func playSound(soundName: String, soundVol: Float) {

        //search for sound
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil)
        else {
            print("path not created")
            return
        }

        let url = URL(fileURLWithPath: path)

        do {  // try to play the sound with AVAudioPlayer
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = soundVol
            player?.play()
        } catch {  // if anything went wrong
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
#Preview {
    SignUp()
}
