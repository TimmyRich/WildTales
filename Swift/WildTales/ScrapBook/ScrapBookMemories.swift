//
//  ScrapBookMemories.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI



struct ScrapBookMemories: View {
    @State private var expandedImage: String? = nil
    
    let images = ["memory1", "memory2", "memory3", "memory4"]
    let positions: [CGSize] = [
        CGSize(width: -80, height: -100),
        CGSize(width: 60, height: 30),
        CGSize(width: 40, height: -200),
        CGSize(width: -100, height: 200)
    ]
    let rotations: [Double] = [ -15, 10, -8, -4 ]
    
    var body: some View {
        ZStack {
            Color("LightPink")
                .edgesIgnoringSafeArea(.all)
            
            ForEach(Array(images.enumerated()), id: \.element) { index, image in
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(positions[index])
                    .rotationEffect(.degrees(rotations[index]))
                    .onTapGesture {
                        withAnimation {
                            expandedImage = image
                        }
                    }
            }
            
            if let selectedImage = expandedImage {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .onTapGesture {
                        withAnimation {
                            expandedImage = nil
                        }
                    }
                
                Image(selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
                    .onTapGesture {
                        withAnimation {
                            expandedImage = nil
                        }
                    }
            }
        }
    }
}




#Preview {
    ScrapBookMemories()
}

