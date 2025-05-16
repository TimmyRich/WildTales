//
//  ScrapBookGuide.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//  Updated by Yujie Wei on 18/4/2025.
//  Scrapbook main page with update visual elements
//  Inspired by https://www.youtube.com/watch?v=OaIn7HBlCSk

import SwiftUI


struct ScrapBookGuide: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var popupManager: PopupManager
    
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
                        
                        Text("Scrapbook").font(Font.custom("Inter", size: 26)).foregroundColor(.green1)
                        
                        Text("Keep all your memories safe!").font(Font.custom("Inter", size: 14)).foregroundColor(.green1).padding(.bottom,20)
                        
                        
                        HStack (spacing: 30) {
                            VStack {
                                NavigationLink(destination: ScrapBookDrag().navigationBarBackButtonHidden(true)) {
                                    Image("albumButton").resizable().frame(width: 60, height: 60)
                                }
                                .hapticOnTouch()
                                
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
                        
                        
                        // Click button for image carousel popup page
                        Button ("Show Image Gallery") {
                            withAnimation(.spring()) {
                                popupManager.present()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width-220, height: 25)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.black), lineWidth: 0.5)
                        )
                        .shadow(radius: 10)
                        .font(Font.custom("Inter", size: 12))
                        
                    }
                    
                    HStack{
                        VStack (alignment: .leading) {
                            
                            Button {
                                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                                dismiss()
                            } label: {
                                Image("homeButtonGreen").resizable().frame(width: 60, height: 60).padding(.top, 40).padding(.leading, 15)
                            }
                            .hapticOnTouch()
                            Spacer()
                            
                        }
                        
                        Spacer()
                    }
                }.overlay(alignment: .bottom) {
                    if popupManager.action.isPresented {
                        ScrapBookPopup {
                            withAnimation(.spring()){
                                popupManager.dismiss()
                            }
                        }
                        
                        
                    }
                }.ignoresSafeArea()
                
            }
        
    }
}

/*
#Preview {
     ScrapBookGuide()
}
 */

struct ScrapBookGuide_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookGuide().environmentObject(PopupManager())
    }
}


