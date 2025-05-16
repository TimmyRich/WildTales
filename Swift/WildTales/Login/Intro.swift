//
//  Intro.swift
//  WildTales
//
//  Created by Kurt McCullough on 25/3/2025.
//
//
// This page is just the intro sequence for Quinn.
// Has a TabView that contains all of the images for the narrative aspect.
// Contains a struct that can load GIFs
// When clicking continue, goes to home page.
//
//
//

import SwiftUI
import WebKit

struct Intro: View {

    @EnvironmentObject var appState: AppState  // if the app has a certain button pressed, it will store it here

    var body: some View {
        ZStack {
            Color("HunterGreen").edgesIgnoringSafeArea(.all)  // as the TabView automatically comes down from the top, this keeps it all green
            TabView {

                ZStack {

                    Image("Narrative 1")  // First image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.all)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )  //fits whole screen

                    HStack {
                        GIFView(gifName: "swipe")  // load swipe gif
                            .frame(width: 100, height: 100)
                            .padding(.bottom, UIScreen.main.bounds.height - 200)  //conform to screen size
                    }
                    Text("Swipe to view more!")  // explainer text
                        .padding(.bottom, UIScreen.main.bounds.height - 320)
                        .font(Font.custom("Inter", size: 15))
                        .foregroundColor(Color("HunterGreen"))

                }

                Image("Narrative 2")  // second image, continues all the same
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
                        Button("Continue") {  // changes app state so it can go to the home page.
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )  //plays boing sound when clicked
                            appState.clickedGo = true  // has finished intro sequence
                            appState.showIntro = false  // dont show the intro any more

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
                        .font(Font.custom("Inter", size: 15))  //custom font
                        .padding(.bottom, 220.0)
                        .hapticOnTouch()  //basic haptic tap

                    }
                    .ignoresSafeArea(edges: .all)  // goes to the edge
                }
                .ignoresSafeArea(edges: .all)
            }
            .tabViewStyle(.page)  //swipe mode
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .ignoresSafeArea(.all)
        }
    }
}

//This part was written by ChatGPT, prompt "this is my code, make it so I can add it to the /*add gif here */ part"
struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            webView.load(request)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    Intro()
}
