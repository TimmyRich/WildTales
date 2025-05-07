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
    var zone: String // 👈 Pass this in
    
    @State private var navigateToMap = false
    
    var body: some View {
        ZStack {
            Color("MapGreen")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height - 500)
                    .clipped()
                    .cornerRadius(16)
                    .padding([.top, .leading, .trailing])
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(4)
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
                    
                    NavigationLink(destination: MapView(zone: zone)
                        .navigationBarBackButtonHidden(true), isActive: $navigateToMap) {
                            EmptyView()
                        }
                    
                    Button(action: {
                        navigateToMap = true
                    }) {
                        Text("Play!")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("HunterGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 6)
            .padding([.leading, .trailing])
        }
    }
}

#Preview {
    NavigationView {
        MapCardView(
            image: Image("PawIcon"),
            title: "Tropical Dome",
            description: "Explore the Tropical Display Dome at Brisbane Botanic Gardens Mt Coot-tha.",
            photoCount: 12,
            zone: "Custom"
        )
    }
}


