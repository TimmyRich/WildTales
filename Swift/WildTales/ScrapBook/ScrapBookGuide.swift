//
//  ScrapBookGuide.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct ScrapBookGuide: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Pink")
                    .ignoresSafeArea()

                Image("guideQuokka")
                    .resizable()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(.all)

                Image("guideText")
                    .resizable()
                    .frame(width: 300, height: 450)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)

                VStack {
                    NavigationLink(destination: ScrapBook().navigationBarBackButtonHidden(true)) {
                        Image("gotItButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 300)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        UserDefaults.standard.set(true, forKey: "hasSeenScrapBookGuide")
                    })
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
                        //.hapticOnTouch()
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ScrapBookGuide()
}
