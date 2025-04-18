//
//  ScrapBookGuide.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//  Updated by Yujie Wei on 18/4/2025.

import SwiftUI

struct ScrapBookGuide: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("scrapbookBackground").resizable().aspectRatio(contentMode: .fill).frame(height: 400)
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("QuokkaCamera")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 170, height: 200,  alignment: .bottom)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width-100, height: 260)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Green1"), lineWidth: 1)
                        ).shadow(radius: 5)
                    Spacer()
                }
                VStack (spacing:10){
                    NavigationLink(destination: ScrapBook().navigationBarBackButtonHidden(true)) {
                        Text("Scrapbook").font(Font.custom("Inter", size: 26)).foregroundColor(.green1)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        UserDefaults.standard.set(true, forKey: "hasSeenScrapBookGuide")
                    })
                    Text("Keep all your memories safe!").font(Font.custom("Inter", size: 14)).foregroundColor(.green1).padding(.bottom,20)
                    
                    HStack (spacing: 30) {
                        VStack {
                            Button {
                                
                            } label: {
                                Image("albumButton").resizable().frame(width: 60, height: 60)
                            }
                            Text("Add from Album").font(Font.custom("Inter", size: 8))
                        }
                        
                        VStack {
                            Button {
                                
                            } label: {
                                Image("cameraButton").resizable().frame(width: 60, height: 60)
                            }
                            Text("Take Photo").font(Font.custom("Inter", size: 8))
                        }
                    }.padding(.bottom,15)
                    
                    NavigationLink(destination: ScrapBookInstruction().navigationBarBackButtonHidden(true)) {
                        Text("Instructions")
                            .frame(width: UIScreen.main.bounds.width-260, height: 25)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.black), lineWidth: 0.5)
                            )
                            .shadow(radius: 10)
                            .font(Font.custom("Inter", size: 12))
                    }
                    .hapticOnTouch()
                }
                
                HStack{
                    VStack (alignment: .leading) {
                        NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                            Image("homeButtonGreen").resizable().frame(width: 50, height: 50)
                            
                        }.simultaneousGesture(TapGesture().onEnded {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            
                        }).hapticOnTouch()
                        Spacer()
                    }
                    
                    Spacer()
                }
            }/*
              .overlay(alignment: .bottom) {
              ScrapBookPopup()
              }.ignoresSafeArea()
              */
        }
    }
}


#Preview {
     ScrapBookGuide()
 }
                
                
                
                
                
                
              
