//
//  Intro.swift
//  WildTales
//
//  Created by Kurt McCullough on 25/3/2025.
//
// This page is just the intro sequence for Quinn, can be viewed more than once unlike "Intro".
// Has a TabView that contains all of the images for the narrative aspect.
// Uses the GIFView from Intro
// When clicking continue, goes back to whatever page it was called from.
//
// Most is the same from "Intro"

import SwiftUI
import WebKit

struct Learn: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack

    var body: some View {
        ZStack {
            Color("HunterGreen").edgesIgnoringSafeArea(.all)
            TabView {
                ZStack {
                    Image("Narrative 1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.all)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )

                    HStack {
                        GIFView(gifName: "swipe")  // show swipe hand
                            .frame(width: 100, height: 100)
                            .padding(.bottom, UIScreen.main.bounds.height - 200)
                    }
                    Text("Swipe to view more!")
                        .padding(.bottom, UIScreen.main.bounds.height - 320)
                        .font(Font.custom("Inter", size: 15))
                        .foregroundColor(Color("HunterGreen"))

                }

                Image("Narrative 2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 6")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 7")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                Image("Narrative 8")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .ignoresSafeArea(.all)

                ZStack {

                    Image("Narrative 9")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.all)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )
                        .ignoresSafeArea(.all)

                    VStack {
                        Button("Continue") {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                            goBack.wrappedValue.dismiss()

                        }
                        .frame(
                            width: UIScreen.main.bounds.width - 300,
                            height: 20
                        )
                        .background(.white)

                        .foregroundColor(Color("HunterGreen"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("HunterGreen"), lineWidth: 1)
                        )
                        .font(Font.custom("Inter", size: 15))
                        .padding(.bottom, 220.0)
                        .hapticOnTouch()

                    }
                    .ignoresSafeArea(edges: .all)
                }
                .ignoresSafeArea(edges: .all)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    Intro()
}
