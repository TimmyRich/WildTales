//
//  Settings.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    @State private var isMusicEnabled: Bool = true
    
    var body: some View {
        VStack {
            
            
            
        
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            List{
                Toggle("Enable Background Music", isOn: $isMusicEnabled)
                    .onChange(of: isMusicEnabled) { value in
                        if value {
                            AudioManager.startBackgroundMusic()
                        } else {
                            AudioManager.stopBackgroundMusic()
                        }
                    }
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
                Toggle("Random ahh toggle", isOn: .constant(true))
                    .padding()
                
    
            }
            .background(Color.green)
            .cornerRadius(20)
                
            
            

            Button("back") {
                dismiss()
            }
            .padding()
            .background(Color("Pink"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Settings()
}
