//
//  ScrapBookInstruction.swift
//  WildTales
//
//  Created by Yujie Wei on 18/4/2025.
//  A instruction page which provides guidances on how to use scrapbook

import SwiftUI

struct ScrapBookInstruction: View {
    @Environment(\.presentationMode) var goBack

    var body: some View {
        ZStack {
            Color("Green2")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("QuokkaScrapbookInstruction")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 135, height: 200, alignment: .bottom)
                        .offset(y: 35)
                }
            }
            
            // Main content area
            VStack(alignment: .leading) {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.17)
                // The outside white card
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 100, height: 360)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Green1"), lineWidth: 1)
                    ).shadow(radius: 5).overlay(
                        VStack(spacing: 8) {
                            Text("Scrapbook").font(
                                Font.custom("Inter", size: 22)
                            ).foregroundColor(.green1).padding(.bottom, 15)
                            // The inner green card 
                            Rectangle()
                                .frame(
                                    width: UIScreen.main.bounds.width - 140,
                                    height: 260
                                )
                                .cornerRadius(20)
                                .foregroundColor(.green2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(.black), lineWidth: 1)
                                ).shadow(radius: 10).overlay(
                                    VStack(spacing: 15) {
                                        Text(
                                            "Take a picture of the place you visited or upload it from your album folder"
                                        ).multilineTextAlignment(.center)
                                            .foregroundColor(.white).font(
                                                Font.custom("Inter", size: 14)
                                            ).frame(
                                                maxWidth: UIScreen.main.bounds
                                                    .width - 170
                                            )
                                        Text(
                                            "Edit it! Cut, change size, add text, stickers, etc"
                                        ).multilineTextAlignment(.center)
                                            .foregroundColor(.white).font(
                                                Font.custom("Inter", size: 14)
                                            ).frame(
                                                maxWidth: UIScreen.main.bounds
                                                    .width - 170
                                            )
                                        Text(
                                            "Collect all in your scrapbook and keep the memories "
                                        ).multilineTextAlignment(.center)
                                            .foregroundColor(.white).font(
                                                Font.custom("Inter", size: 14)
                                            ).frame(
                                                maxWidth: UIScreen.main.bounds
                                                    .width - 170
                                            ).padding(.bottom, 25)
                                        Button {
                                            AudioManager.playSound(
                                                soundName: "boing.wav",
                                                soundVol: 0.5
                                            )
                                            goBack.wrappedValue.dismiss()
                                        } label: {
                                            Text("Go Back")
                                                .frame(
                                                    width: UIScreen.main.bounds
                                                        .width - 270,
                                                    height: 30
                                                ).background(Color(.white))
                                                .foregroundColor(.black)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(
                                                        cornerRadius: 10
                                                    )
                                                    .stroke(
                                                        Color(.black),
                                                        lineWidth: 0.5
                                                    )
                                                ).font(
                                                    Font.custom(
                                                        "Inter",
                                                        size: 16
                                                    )
                                                )
                                        }.hapticOnTouch()

                                    }
                                )
                        }
                    )
                Spacer()
            }
        }
    }
}

#Preview {
    ScrapBookInstruction()
}

