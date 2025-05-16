//
//  MapChoice.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//
//
//  Basic view to change between the community map, present maps and custom map
//


import AVFoundation // sound content
import CoreHaptics // haptics when nessesary
import MapKit // maps
import SwiftUI // forming ui's

struct MapChoice: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack

    @StateObject private var locationManager = LocationManager()
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    ) //basic zoom into brisbane if location is not provided

    @State private var locations = [Location]()
    @State private var isMapLoaded = false

    var body: some View {

        NavigationView {
            ZStack {
                Map( //load map to have it as the background
                    coordinateRegion: $mapRegion,
                    interactionModes: .all,
                    userTrackingMode: .none,
                    annotationItems: locations
                ) { location in
                    MapMarker( //no locations should be loaded in but this is needed to load them map
                        coordinate: CLLocationCoordinate2D(
                            latitude: location.latitude,
                            longitude: location.longitude
                        )
                    )
                }
                .ignoresSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.userLocation) { newLocation in //when map loads
                    if let newLocation = newLocation, !isMapLoaded {
                        mapRegion.center = newLocation.coordinate
                        isMapLoaded = true
                    }
                }
                ZStack {
                    Rectangle() //background white rectangle
                        .foregroundColor(.white)
                        .frame(width: 300, height: 500)
                        .cornerRadius(20)
                    VStack {

                        Text("Select or Create a Map!")

                        NavigationLink(
                            destination: CommunityMapView() // go to community map
                                .navigationBarBackButtonHidden(true) //dont show navigation menu options, this usually has a back button but we are using our own
                        ) {
                            Image("community")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 100)
                        }.simultaneousGesture(
                            TapGesture().onEnded {
                                AudioManager.playSound(
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }
                        )
                        .padding()

                        NavigationLink(
                            destination: CreateMapView() //create map view
                                .navigationBarBackButtonHidden(true)
                        ) {
                            Image("create")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 100)
                        }.simultaneousGesture( // also do this when clicked
                            TapGesture().onEnded {
                                AudioManager.playSound( //play sound effect
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }
                        )
                        .padding()

                        NavigationLink(
                            destination: MapZones() // go to map zones to choose here
                                .navigationBarBackButtonHidden(true)
                        ) {
                            Image("cexisting")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 100)
                        }.simultaneousGesture(
                            TapGesture().onEnded {
                                AudioManager.playSound(
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }
                        )
                        .padding()
                    }
                    HStack {
                        VStack {
                            Button(action: {
                                goBack.wrappedValue.dismiss() // go to previous view before this (usually home)
                                AudioManager.playSound(
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("HunterGreen"))
                                    .frame(width: 60, height: 60)

                                    .shadow(radius: 5)
                                //.hapticOnTouch()
                            }
                            Spacer()

                        }
                        .padding(.leading, 0.0)
                        Spacer()
                    }
                    .padding(.leading)

                }

            }

        }.preferredColorScheme(.light) //alwsys light map

    }
}

#Preview {
    MapChoice()
}
