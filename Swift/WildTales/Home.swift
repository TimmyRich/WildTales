//
//  Home.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//
//Home page, just a NavigationView that redirects to differeent views within the application

import SwiftUI

struct Home: View {
    @EnvironmentObject var appState: AppState

    @State private var showEmergency = false  // variable to show emergency

    var body: some View {
        NavigationView {
            ZStack {
                Image("home")  // background and styling
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .all)  // fill to corners
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height  // over whole screen
                    )

                VStack {
                    HStack {
                        Spacer()

                        Image("Quokka_2")  //quokka image and styling
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: UIScreen.main.bounds.width / 4,
                                height: UIScreen.main.bounds.height / 4
                            )
                            .ignoresSafeArea(.all)
                    }

                    Spacer()
                }

                VStack {  //just the emergency button and styling
                    HStack {
                        Button(action: {
                            AudioManager.playSound(
                                soundName: "siren.wav",
                                soundVol: 0.5
                            )
                            showEmergency = true  // for emergency toggle
                        }) {
                            Image(systemName: "phone.connection.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Circle().fill(Color.red))
                                .shadow(radius: 5)
                                .padding()  // so its not sitting on the edge
                        }
                        .padding()

                        Spacer()
                    }

                    Spacer()
                }

                Image("logoTitle")  //logo image and styling
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 200)

                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            NavigationLink(
                                destination: MapChoice()  // go to select maps
                                    .navigationBarBackButtonHidden(true)  //dont show navigation bar or details
                            ) {
                                Image("homeButton2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(
                                TapGesture().onEnded {  // play sound when clicked
                                    AudioManager.playSound(
                                        soundName: "boing.wav",
                                        soundVol: 0.5
                                    )
                                }
                            )

                            NavigationLink(
                                destination: ScrapBookGuide()  //go to scrapbook
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                Image("homeButton4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(
                                TapGesture().onEnded {
                                    AudioManager.playSound(
                                        soundName: "boing.wav",
                                        soundVol: 0.5
                                    )
                                }
                            )
                        }
                        Spacer()

                        VStack {

                            NavigationLink(
                                destination: GalleryView()  // go to gallery
                                    .navigationBarBackButtonHidden(true)
                                    .preferredColorScheme(.light)
                            ) {
                                Image("homeButton1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(
                                TapGesture().onEnded {
                                    AudioManager.playSound(
                                        soundName: "boing.wav",
                                        soundVol: 0.5
                                    )
                                }
                            )

                            NavigationLink(
                                destination: Learn()  //learn about quinn again
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                Image("homeButton3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }.simultaneousGesture(
                                TapGesture().onEnded {
                                    AudioManager.playSound(
                                        soundName: "boing.wav",
                                        soundVol: 0.5
                                    )
                                }
                            )

                        }
                        Spacer()
                    }
                    .padding(.top, 350)
                }
            }
            .overlay(
                Group {
                    if showEmergency {  // if th emergency button is clicked, open the emergency toggle
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture { showEmergency = false }

                            Emergency(showEmergency: $showEmergency)
                                .transition(.scale)
                        }
                    }
                }
            )
            .onAppear {
                AudioManager.startBackgroundMusic()  //starts background music
            }

        }
    }
}

#Preview {
    Home()
}
