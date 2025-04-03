//
//  CommunityMapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//
import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct CommunityMapView: View {
    
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var goBack
    
    @State private var showEmergency = false
    
    @StateObject private var locationManager = LocationManager()
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )
    
    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true, // Show blue dot
                userTrackingMode: .none,
                annotationItems: locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
            .ignoresSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation, !isMapInitialized {
                    mapRegion.center = newLocation.coordinate
                    isMapInitialized = true
                }
            }
            
            VStack {
                HStack {

                    
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    
                
                    Spacer()
                    
                    Button(action: {
                        showEmergency = true
                        AudioManager.playSound(soundName: "siren.wav", soundVol: 0.5)
                    }) {
                        Image(systemName: "phone.connection.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.red))
                            .shadow(radius: 5)
                            .padding()
                    }
                    
                    
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    // Add Location Button

                    
                    // Stories Button
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "book")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    Spacer()
                    
                    
                    Button {
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }.simultaneousGesture(TapGesture().onEnded {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                    })
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    
                    
                }
            }
            .overlay(
                Group {
                    if showEmergency {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture { showEmergency = false }

                            Emergency(showEmergency: $showEmergency)
                                .transition(.scale)
                        }
                    }
                }
            )
        }
        .sheet(isPresented: $showSheet) {
            Stories()
        }
        .sheet(isPresented: $showSettingsSheet) {
            Settings()
        }
    }
}

#Preview {
    CommunityMapView()
}


