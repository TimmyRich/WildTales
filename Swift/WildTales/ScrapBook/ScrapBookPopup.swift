//
//  ScrapBookPopup.swift
//  WildTales
//
//  Created by Yujie Wei on 18/4/2025.
//  Reference https://stackoverflow.com/questions/56760335/how-to-round-specific-corners-of-a-view

import SwiftUI

struct ScrapBookPopup: View {
    
    let didClose: () -> Void
    let ImageList: [ImageItem] = sampleImageList
    
    @State private var currentIndex: Int = 0

    var body: some View {
            GeometryReader { geometry in
                
                ZStack {
                    // Background Color to fill the gap
                    /*Color(.green1)
                         .frame(height: 150) // Adjust height
                         .frame(maxHeight: .infinity, alignment: .top)
                         .ignoresSafeArea(.container, edges: .top)*/

                    VStack(spacing: 0) {
                        Header(closeAction: didClose)
                            .padding(.bottom, 20)

                        CarouselView(CarouselImage: ImageList, currentIndex: $currentIndex)
                             .frame(height: geometry.size.height * 0.7)

                        Spacer()
                    }
                    .background(Color(.white))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .padding(.top, 80)
                }
            }
            .transition(.move(edge: .bottom))
        }
    }

struct Header: View {
    var closeAction: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text("Memories")
                    .font(.title)
                    .foregroundColor(Color(.green1))
                
                Text("Look back at all your adventures")
                    .font(.subheadline)
                    .foregroundColor(Color(.gray))
            }
            .padding(.horizontal, 25)
            .padding(.top, 40)
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        closeAction()
                    } label: {
                        
                        Image("exitButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 35)
                    }
                    Spacer()
                }
                .padding(.bottom, 40)
            }
            
        }
        
    }
}

struct CarouselView: View {
    let CarouselImage: [ImageItem]
    @Binding var currentIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(CarouselImage.indices, id: \.self) { index in
                        CardView(memory: CarouselImage[index])
                            .padding(.horizontal, 25)
                            .frame(width: geometry.size.width)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: geometry.size.height)
                
                HStack {
                    // Left
                    Button {
                        withAnimation { currentIndex = max(0, currentIndex - 1) }
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(.green1))
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                    // Right
                    Button {
                        withAnimation { currentIndex = min(CarouselImage.count - 1, currentIndex + 1) }
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(.green1))
                    }
                    .padding(.trailing, 5)
                }
                // adjust vertical position of arrow buttons relative to the area
                .padding(.top, geometry.size.height * 0.3)
            }
        }
    }
}
    
struct CardView: View {
    let memory: ImageItem
    
    var body: some View {
        VStack(spacing: 15) {
            // Title
            Text(memory.locationTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.top, 10)
            
            // Image
            // within the zstack
            ZStack {
                Image(memory.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 300)
                    .clipped()
                    .cornerRadius(8)
            }
            .frame(maxHeight: 300)
            // photo ratio 4/3
            .aspectRatio(4/3, contentMode: .fit)
            
            // Text
            Text("\"\(memory.description)\"")
                .font(Font.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}


// Change the corner or the card, inspired by post from stackoverflow
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ScrapBookPopup_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookPopup(didClose: {})
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}




