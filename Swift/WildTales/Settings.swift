//
//  Settings.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    @State private var isMusicEnabled: Bool = true  //default music playing
    @State private var selectedTime: Date = Date()  // Use for temporary notification, uneeded as code is commented out

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button {  // back button goes to the previous page
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        dismiss()  //go to previous view
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))

                    .shadow(radius: 5)
                    .padding([.top, .leading], 30.0)
                    
                    Spacer()
                    
                }
                Spacer()
            }
            VStack {
                
                Text("Settings")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    Toggle("Enable Background Music", isOn: $isMusicEnabled)
                        .onChange(of: isMusicEnabled) { value in
                            if value {
                                AudioManager.startBackgroundMusic()  //asks the auto manager to start music
                            } else {
                                AudioManager.stopBackgroundMusic()  // stop of not selected, mute button also works
                            }
                        }
                        .padding()
                    
                }
                .background(Color.green)
                .cornerRadius(20)
                
                
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Settings()
}
