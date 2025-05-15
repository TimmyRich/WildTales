//
//  MapZones.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//
//
// Shows all the zones to play: three in brisbane and the custom and the end
// All hard coded and do not loop through all avalible zones
//
// TabView so the user has to swipe through it, GIF communicaes this
//
// Clicking play redirects to MapView with a specific zone.

import SwiftUI
import WebKit

struct MapZones: View {

    @State private var selectedTab = 0  // shows the index of tab for white dots
    @Environment(\.presentationMode) var goBack  // to go back to previous navigation view

    @State private var showGIF = true

    var body: some View {
        ZStack {

            Color("MapGreen").edgesIgnoringSafeArea(.all)  //keep a consistant background, removes white bar
            TabView(selection: $selectedTab) {
                MapCardView( // for botanical gardens
                    image: Image("gardens"),
                    title: "Mt Coot-tha Botanic Gardens",
                    description:
                        "The Brisbane Botanic Gardens at Mount Coot-tha is a beautiful garden full of different plants from around the world. You can explore tropical plants in a big dome, see cool bonsai trees, visit a Japanese garden, and even walk through a bamboo grove.",
                    photoCount: 10,
                    zone: "Botanical Gardens"
                )
                .tag(0)
                .ignoresSafeArea()

                MapCardView( // for uq
                    image: Image("uq"),
                    title: "University of Queensland",
                    description:
                        "The University of Queensland (UQ) is a big, beautiful university in Brisbane where students go to learn and study. It has lots of green spaces, cool buildings, and even a famous library. UQ is a great place for exploring, with lots of exciting things to see and do, like visiting the nearby botanical gardens and learning about science, animals, and nature!",
                    photoCount: 12,
                    zone: "University of Queensland"
                )
                .tag(1) //shows the index how many tabs, this is the second tab
                .ignoresSafeArea()

                MapCardView( // southbank card
                    image: Image("southbank"),
                    title: "Southbank Parklands",
                    description:
                        "South Bank Parklands is a fun place in Brisbane where kids can play, swim, and explore. You can build sandcastles at Streets Beach, splash around at Aquativity, or play on the giant slides at Riverside Green Playground. There’s also a big wheel called the Wheel of Brisbane that gives you a bird’s-eye view of the city. It’s a great spot for families to enjoy the outdoors and have fun together!",
                    photoCount: 12,
                    zone: "Southbank Parklands"
                )
                .tag(2)
                .ignoresSafeArea()

                MapCardView( //custom icon
                    image: Image("PawIcon"), //default if no image
                    title: "Custom Map",
                    description:
                        "Walk through a custom map that your parents have created for you. Don't forget to stay safe!",
                    photoCount: 12,
                    zone: "Custom"
                )
                .tag(3)
                .ignoresSafeArea()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // shows the white dots in terms of view
            .background(Color.clear)

            // Back Button
            HStack {
                VStack {
                    Button {
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss() // go back to select map
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
                    GIFView(gifName: "swipe") // swipe gif
                        .frame(width: 70, height: 70)
                        .padding(.top, UIScreen.main.bounds.height - 200)
                }
            }

        }
        .onAppear {
            // Hide the GIF after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { //timer for 10 second hand showing the fading
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
