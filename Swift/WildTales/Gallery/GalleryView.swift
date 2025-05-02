import SwiftUI

struct GalleryView: View {
    
    let imageNames = ["Botanical Gardens", "Botanical Gardens Night Time", "Sunny Fields", "Beach"]
    let buttonImages = ["forward_button", "back_button"]
    
    @State private var selectedIndex = 0
    @Environment(\.presentationMode) var goBack
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 191/255, green: 209/255, blue: 161/255)
                    .ignoresSafeArea()
                
                // Quokka image
                /*Image("quokka")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.2)
                    .offset(x: 100, y: -370)*/

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
                        Button { // back button goes to the previous page
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            goBack.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill").resizable()
                        }
                        
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20)
                        .shadow(radius: 5)
                        .padding(.top, 150)
                        

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
