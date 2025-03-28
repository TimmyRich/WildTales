//
//  Landing.swift
//  SwiftUI Demo
//
//  Created by Kurt McCullough on 24/3/2025.
//

import SwiftUI
import AVFoundation
import SpriteKit
import CoreHaptics

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
                    .padding(.trailing, UIScreen.main.bounds.width-200)
                    .padding(.bottom, 330)
                
                Spacer()
                
            }
            
            VStack {
                Spacer()
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width-130, height: 340)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Pink"), lineWidth: 1)).shadow(radius: 5)
                
                Spacer()
                
            }
            
            VStack {
                
                Spacer()
                Text("Sign Up")
                    .font(Font.custom("Inter", size: 25))
                    .padding(.vertical, 20)
                
                TextField("Name", text: $name)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("LightGrey")/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Username/Email", text: $username)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("LightGrey")/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .font(Font.custom("Inter", size: 15))
                    .frame(width: UIScreen.main.bounds.width - 150, height: 30)
                    .foregroundColor(Color.gray)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("LightGrey")/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 20)
                
                
                
                Button("Login") {
                    appState.showIntro = true
                    playSound(soundName: "boing.wav", soundVol: 0.5)
                }.frame(width: UIScreen.main.bounds.width-150, height: 30)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("Pink")/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Pink"), lineWidth: 1)).shadow(radius: 10)
                    .font(Font.custom("Inter", size: 15))
                    .hapticOnTouch()
                
                Text("───  Access Quickly  ───")
                    .font(Font.custom("Inter", size: 10))
                    .padding(.vertical, 10)
                
                HStack {
                    Button("Google") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)
                        
                    }   .frame(width: UIScreen.main.bounds.width-300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Pink"), lineWidth: 1))
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                    
                    
                    Button("iCloud") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)
                        
                    }.frame(width: UIScreen.main.bounds.width-300, height: 20)
                        .background(.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Pink"), lineWidth: 1))
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                    
                }
                
                HStack {
                    
                    Text("Already have an account?")
                        .font(Font.custom("Inter", size: 10))
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                    
                    Button("Log In") {
                        playSound(soundName: "boing.wav", soundVol: 0.5)
                        dismiss()
                        
                    }.frame(width: 50, height: 20)
                        .background(.white)
                        .foregroundColor(Color("Pink"))
                        .cornerRadius(10)
                    
                    
                        .font(Font.custom("Inter", size: 10))
                        .hapticOnTouch()
                    
                }
                Spacer()
            }.padding(.bottom)
        }
    }
    
    func playSound(soundName: String, soundVol: Float ) {
        
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil ) else {
            print("path not created")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = soundVol
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    
}


#Preview {
    SignUp()
}
