import SwiftUI

struct GalleryView: View {
    
    let imageNames = ["Botanical Gardens", "Botanical Gardens Night Time", "Sunny Fields", "Beach"]
    let buttonImages = ["forward_button", "back_button"]
    
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 191/255, green: 209/255, blue: 161/255)
                    .ignoresSafeArea()
                
                // Quokka image
                Image("quokka")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.2)
                    .offset(x: 100, y: -370)

                Image("GalleryBackgroundRect")
                    .resizable()
                    .scaledToFit()
                    .offset(y: 30)

                VStack {
                    Spacer().frame(height: 200)
                    
                    TabView(selection: $selectedIndex) {
                        ForEach(0..<imageNames.count, id: \.self) { index in
                            NavigationLink(destination: BadgeDecoratorView(imageName: imageNames[index])) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .frame(width: 320, height: 660)
                                    
                                    VStack {
                                        Text("The \(imageNames[selectedIndex]) trail")
                                            .padding(.bottom, 10)
                                            .font(.headline)
                                        
                                        Image(imageNames[index])
                                            .resizable()
                                            .frame(width: 300, height: 600)
                                            .cornerRadius(10)
                                    }
                                }
                                .tag(index)
                                .shadow(radius: 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 800)
                }

                // Carousel navigation buttons
                VStack {
                    HStack {
                        Button(action: {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            }
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
                        }) {
                            Image("forward_button")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, -10)
                        }
                    }
                    .padding()
                }

                // 🏠 Home Button (Top-left)
                HStack {
                    VStack(alignment: .leading) {
                        NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                            Image("homeButtonGreen")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        })
                        .padding(.top, 75)
                        .hapticOnTouch()

                        Spacer()
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    GalleryView()
}
