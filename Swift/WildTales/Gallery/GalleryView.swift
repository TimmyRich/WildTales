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
                
                // Quokka image, moved upwards so its bottom is hidden
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
                    Spacer().frame(height:200)
                    
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
                
                // Left and right buttons to control carousel
                VStack {
                    HStack {
                        Button(action: {
                            // Go to the previous image in the carousel
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
                            // Go to the next image in the carousel
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
            }
        }
    }
}

#Preview {
    GalleryView()
}
