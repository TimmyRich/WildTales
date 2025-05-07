//
//  CardView.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//

import SwiftUI

struct MapCardView: View {
    var image: Image
    var title: String
    var description: String
    var photoCount: Int
    
    var body: some View {
        ZStack{
            Color("MapGreen")
                            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height-400) // Make image span full screen width
                    .clipped()
                    .cornerRadius(16)
                    .padding([.top, .leading, .trailing])
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .lineLimit(2) // Limit the title to two lines
                        .truncationMode(.tail)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(4) // Limit the description to four lines
                        .truncationMode(.tail)
                }
                .padding(.horizontal)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "photo")
                        Text("\(photoCount)")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Play tapped")
                    }) {
                        Text("Play!")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("HunterGreen")) // Add this color to Assets or use Color.green
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .background(Color.white) // Set the entire card's background to green
            .cornerRadius(24)
            .shadow(radius: 6)
            .padding([.leading, .trailing]) // Adjust padding to only apply horizontally
        }
    }
}

#Preview {
    MapCardView(image: Image("PawIcon"), // Add this image to Assets
             title: "Tropical Dome",
             description: "Explore the Tropical Display Dome at Brisbane Botanic Gardens Mt Coot-tha, designed by Brisbane City Council architect Jacob de Vries.",
             photoCount: 12)
}

