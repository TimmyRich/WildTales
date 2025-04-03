//
//  ScrapBook.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct ScrapBook: View {
    
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        ZStack{
            
            
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
