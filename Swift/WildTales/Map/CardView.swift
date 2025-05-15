//
//  CardView.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//
//
//  Basic card view for each map in Present Maps.
//  Contains a large image, dtext/description and a play button that will take you to a specific zone to play
//

import SwiftUI

struct MapCardView: View {
    // All these are used in displaying a proper card
    var image: Image  //image to use
    var title: String  // title of map
    var description: String  // description of map
    var photoCount: Int  // number of map pins (simulated)
    var zone: String  //zone for the MapView to search for

    @State private var navigateToMap = false  // if the map view is to be shown

    var body: some View {

        ZStack {
            Color("MapGreen")
                .edgesIgnoringSafeArea(.all)  // as there was a white bar on top of the view, removes this

            VStack(spacing: 16) {  //image formatting, this sits on top of the text
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width - 60,
                        height: UIScreen.main.bounds.height - 500
                    )
                    .clipped()
                    .cornerRadius(16)
                    .padding([.top, .leading, .trailing])

                VStack(alignment: .leading, spacing: 8) {  // title and description text on top of one another under the image
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .lineLimit(2)  //no more than 2 lines can be shown
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
                        Text("\(photoCount)")  // simulated photo (pin) count
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    Spacer()

                    NavigationLink(
                        destination: MapView(zone: zone)  //zone to go to
                            .navigationBarBackButtonHidden(true),
                        isActive: $navigateToMap  //goes to map with destination of "zone"
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        navigateToMap = true  // when clicked go to map
                    }) {
                        Text("Play!")  // Play! button
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("HunterGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(
                                color: .gray.opacity(0.4),
                                radius: 4,
                                x: 2,
                                y: 2
                            )
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

// Basic preview of inputs into the MapCardView
// Contains an image, title, description, photo count and view.
#Preview {
    NavigationView {
        MapCardView(
            image: Image("PawIcon"),
            title: "Tropical Dome",
            description:
                "Explore the Tropical Display Dome at Brisbane Botanic Gardens Mt Coot-tha.",
            photoCount: 12,
            zone: "Custom"
        )
    }
}
