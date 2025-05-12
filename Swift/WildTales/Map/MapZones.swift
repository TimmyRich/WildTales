//
//  MapZones.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//

import SwiftUI
import WebKit

struct MapZones: View {

    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var goBack

    @State private var showGIF = true

    var body: some View {
        ZStack {

            Color("MapGreen").edgesIgnoringSafeArea(.all)
            TabView(selection: $selectedTab) {
                MapCardView(
                    image: Image("gardens"),
                    title: "Mt Coot-tha Botanic Gardens",
                    description:
                        "The Brisbane Botanic Gardens at Mount Coot-tha is a beautiful garden full of different plants from around the world. You can explore tropical plants in a big dome, see cool bonsai trees, visit a Japanese garden, and even walk through a bamboo grove.",
                    photoCount: 12,
                    zone: "Botanical Gardens"
                )
                .tag(0)
                .ignoresSafeArea()

                MapCardView(
                    image: Image("uq"),
                    title: "University of Queensland",
                    description:
                        "The University of Queensland (UQ) is a big, beautiful university in Brisbane where students go to learn and study. It has lots of green spaces, cool buildings, and even a famous library. UQ is a great place for exploring, with lots of exciting things to see and do, like visiting the nearby botanical gardens and learning about science, animals, and nature!",
                    photoCount: 12,
                    zone: "University of Queensland"
                )
                .tag(1)
                .ignoresSafeArea()

                MapCardView(
                    image: Image("southbank"),
                    title: "Southbank Parklands",
                    description:
                        "South Bank Parklands is a fun place in Brisbane where kids can play, swim, and explore. You can build sandcastles at Streets Beach, splash around at Aquativity, or play on the giant slides at Riverside Green Playground. There’s also a big wheel called the Wheel of Brisbane that gives you a bird’s-eye view of the city. It’s a great spot for families to enjoy the outdoors and have fun together!",
                    photoCount: 12,
                    zone: "Southbank Parklands"
                )
                .tag(2)
                .ignoresSafeArea()

                MapCardView(
                    image: Image("PawIcon"),
                    title: "Custom Map",
                    description:
                        "Walk through a custom map that your parents have created for you. Don't forget to stay safe!",
                    photoCount: 12,
                    zone: "Custom"
                )
                .tag(3)
                .ignoresSafeArea()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .background(Color.clear)

            // Back Button
            HStack {
                VStack {
                    Button {
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 40))
                            .foregroundColor(Color("HunterGreen"))
                            .shadow(radius: 5)
                    }
                    .padding(.all, 30.0)
                    .padding(.top, 30.0)

                    Spacer()
                }
                Spacer()
            }

            HStack {
                if showGIF {
                    GIFView(gifName: "swipe")
                        .frame(width: 70, height: 70)
                        .padding(.top, UIScreen.main.bounds.height - 200)
                }
            }

        }
        .onAppear {
            // Hide the GIF after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation {
                    showGIF = false
                }
            }
        }
        .ignoresSafeArea(.all)  // Ensure no safe area interference for the whole screen
    }
}

#Preview {
    MapZones()
}
