//
//  Emergency.swift
//  WildTales
//
//  Created by Kurt McCullough on 3/4/2025.
//
// Emergency Page View, just a few buttos that redirect within the iPhone

import SwiftUI

struct Emergency: View {
    @Binding var showEmergency: Bool
    @State private var showAlert = false

    var body: some View {

        ZStack {

            VStack(spacing: 20) {
                Text("Feeling Lost?")
                    .font(.title2)
                    .fontWeight(.bold)

                Button("Call your parents?") {
                    AudioManager.playSound(
                        soundName: "siren.wav",
                        soundVol: 0.5
                    )
                    if let url = URL(string: "tel://0434797833") {
                        UIApplication.shared.open(url) //prompt to call parents number
                    }
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.orange)
                .cornerRadius(10)

                Button("Find your parents!") {
                    AudioManager.playSound(
                        soundName: "siren.wav",
                        soundVol: 0.5
                    )

                    if let url = URL(string: "findmy://") { //open the find my application
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }

                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)

                Image("unsafe")
                    .resizable()
                    .frame(width: 170, height: 150)
                    .padding(.trailing, 100)

                Text("Feeling Unsafe?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Button("Find security ") {
                    AudioManager.playSound(
                        soundName: "siren.wav",
                        soundVol: 0.5
                    )
                    let searchQuery = "police" // search query in apple maps for police
                    if let url = URL(string: "maps://?q=\(searchQuery)") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.purple)
                .cornerRadius(10)

                Button("Rescue") {
                    showAlert = true // variable to show the rescue prompt
                }
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
                .alert(isPresented: $showAlert) { //alert for rescue button
                    Alert(
                        title: Text("WARNING: THIS WILL CALL 000"),
                        message: Text(
                            "Press the side button 5 times to trigger the emergency call.\n \nThen swipe the red slider to confirm."
                        ),
                        primaryButton: .default(Text("OK")), //dismiss on OK or cancel
                        secondaryButton: .cancel()
                    )
                }

            }
            .frame(width: 350, height: 600)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)

            Button(action: {
                showEmergency = false // when X is clicked
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Pink"))
                    .clipShape(Circle())
            }.simultaneousGesture(
                TapGesture().onEnded {
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                }
            )
            .padding(.trailing, 280)
            .padding(.bottom, 520)

            HStack {
                Spacer()

                Image("Quokka_1")
                    .resizable()
                    .frame(width: 160, height: 240)
                    .rotationEffect(Angle(degrees: -50))
                    .padding(.top, 100)
                    .padding(.leading, 300)

            }
        }
    }
}

#Preview {
    Emergency(showEmergency: .constant(true))
}
