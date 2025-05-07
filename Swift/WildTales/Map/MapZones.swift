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
    
    // State to keep track of the selected tab
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        ZStack{
            // Full-screen content view
            TabView(selection: $selectedTab) {
                
                MapCardView(image: Image("PawIcon"),
                            title: "Mt Coot-tha Botanic Gardens",
                            description: "The Brisbane Botanic Gardens at Mount Coot-tha is a beautiful garden full of different plants from around the world. You can explore tropical plants in a big dome, see cool bonsai trees, visit a Japanese garden, and even walk through a bamboo grove.",
                            photoCount: 12,
                            zone: "Botanical Gardens")
                    .tag(0)
                
                MapCardView(image: Image("PawIcon"),
                            title: "University of Queensland",
                            description: "The University of Queensland (UQ) is a big, beautiful university in Brisbane where students go to learn and study. It has lots of green spaces, cool buildings, and even a famous library. UQ is a great place for exploring, with lots of exciting things to see and do, like visiting the nearby botanical gardens and learning about science, animals, and nature!",
                            photoCount: 12,
                            zone: "University of Queensland")
                    .tag(1)
                
                MapCardView(image: Image("PawIcon"),
                            title: "Southbank Parklands",
                            description: "South Bank Parklands is a fun place in Brisbane where kids can play, swim, and explore. You can build sandcastles at Streets Beach, splash around at Aquativity, or play on the giant slides at Riverside Green Playground . There’s also a big wheel called the Wheel of Brisbane that gives you a bird’s-eye view of the city . It’s a great spot for families to enjoy the outdoors and have fun together!",
                            photoCount: 12,
                            zone: "Southbank Parklands")
                    .tag(2)
                
                MapCardView(image: Image("PawIcon"),
                            title: "Custom Map",
                            description: "Walk through a custom map that your parents have created for you. Don't forget to stay safe!",
                            photoCount: 12,
                            zone: "Custom")
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the dots
            .ignoresSafeArea(.all) // Make sure the TabView ignores safe areas
            
            // Back Button
            HStack{
                VStack{
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 40))
                            .foregroundColor(Color("HunterGreen"))
                            .shadow(radius: 5)
                    }
                    .padding(.leading, 30.0)
                    
                    Spacer()
                }
                Spacer()
            }
            
            // Arrow Buttons
            VStack {
                Spacer()
                HStack {
                    // Left Arrow Button
                    Button(action: {
                        withAnimation {
                            if selectedTab > 0 {
                                selectedTab -= 1
                            }
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.hunterGreen) // Green icon
                            .padding(10)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    // Right Arrow Button
                    Button(action: {
                        withAnimation {
                            if selectedTab < 3 {
                                selectedTab += 1
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.hunterGreen) // Green icon
                            .padding(10)
                    }
                    .padding(.top)
                }
            }
        }
        .edgesIgnoringSafeArea(.all) // Make sure to ignore safe area on the entire ZStack
        .padding(.bottom) // Optional padding for the bottom (adjust as needed)
    }
}

#Preview {
    MapZones()
}






