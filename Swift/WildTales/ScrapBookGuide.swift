//
//  ScrapBookGuide.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct ScrapBookGuide: View {
    @Environment(\.presentationMode) var presentationMode
    
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
            }
        }
    }
}

#Preview {
    ScrapBookGuide()
}
