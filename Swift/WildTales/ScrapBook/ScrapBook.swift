//
//  ScrapBook.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//  Old version of Scrapbook

import SwiftUI

import SwiftUI

struct ScrapBook: View {
    
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        ZStack{
            // TabView with custom accent color
            TabView {
                
                ScrapBookMemories()
                    .tabItem {
                        Label("Memories", systemImage: "memories")
                    }

                ScrapBookEdit()
                    .tabItem {
                        Label("Edit", systemImage: "scissors")
                    }
            }
            .accentColor(.white)  // Set the color of the tab items to blue (or any color you prefer)
            
            HStack{
                VStack{
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    Spacer()
                    
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ScrapBook()
}


