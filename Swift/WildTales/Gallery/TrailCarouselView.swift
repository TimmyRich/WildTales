import SwiftUI

struct TrailCarouselView: View {
    let imageNames: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        VStack {
            Spacer().frame(height: 200)

            TabView(selection: $selectedIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    NavigationLink(destination: BadgeDecoratorView(trailName: imageNames[index])) {
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

            // Navigation buttons
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
    }
}
