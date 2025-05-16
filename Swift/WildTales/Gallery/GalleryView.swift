/*
 -- Acknowledgments --

 ChatGPT was used to modularise the TrailCarouselView, see TrailCarouselView.swift
 for prompt.
 */

import SwiftUI

// Gallery view for selecting which digital artwork to decorate
struct GalleryView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    let imageNames = [
        "Botanical Gardens", "Botanical Gardens Night Time", "Sunny Fields",
        "Beach",
    ]
    let buttonImages = ["forward_button", "back_button"]

    @State private var selectedIndex = 0
    @Environment(\.presentationMode) var goBack

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 191 / 255, green: 209 / 255, blue: 161 / 255)
                    .ignoresSafeArea()
                VStack {
                    Image("quokka")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight * 0.15)
                        .offset(x: screenWidth * 0.3, y: screenHeight * 0.07)
                    ZStack {
                        Rectangle()
                            .cornerRadius(60)
                            .foregroundColor(.lightGrey)
                            
                        VStack {
                            Text("Gallery")
                                .font(.system(size: 32, design: .default))
                                .foregroundStyle(.green1)
                            Text("Select your trail")
                                .foregroundStyle(.grey)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.top, 75)

                VStack {
                    Spacer().frame(height: 200)

                    TabView(selection: $selectedIndex) {
                        ForEach(0..<imageNames.count, id: \.self) { index in
                            NavigationLink(
                                destination: BadgeDecoratorView(
                                    trailName: imageNames[index]
                                )
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .frame(
                                            width: screenWidth * 0.85,
                                            height: screenHeight
                                        )
                                        .offset(y: screenHeight * 0.16)

                                    VStack {
                                        Text(
                                            "The \(imageNames[selectedIndex]) trail"
                                        )
                                        .padding(.bottom, 10)
                                        .font(.headline)

                                        Image(imageNames[index])
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            
                                    }.padding(.top, screenHeight * 0.17)
                                }
                                .tag(index)
                                .shadow(radius: 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: screenHeight)
                }

                // Carousel navigation buttons
                VStack {
                    HStack {
                        Button(action: {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            }
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }) {
                            Image("back_button")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading, -10)
                        }

                        Spacer()

                        Button(action: {
                            if selectedIndex < imageNames.count - 1 {
                                selectedIndex += 1
                            }
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }) {
                            Image("forward_button")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, -10)
                        }
                    }
                    .padding()
                }
                
                // Home Button
                HStack {
                    VStack {
                        Button {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                            goBack.wrappedValue.dismiss()
                        } label: {
                            ExitButton()
                        }
                        Spacer().frame(height: screenHeight * 0.6)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GalleryView()
}
