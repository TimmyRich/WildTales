//
//  MapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 22/3/2025.
//

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct MapView: View {
    
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
    
    @State private var selectedLocation: Location?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations) { location in
                
                MapAnnotation(coordinate: location.coordinate) {
                    Button {
                        withAnimation {
                            selectedLocation = location
                        }
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .shadow(radius: 2)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
                locations = LocationLoader.loadLocations()
                
                // Request permission for notifications
                ProximityNotificationManager.shared.requestPermission()
                
                // Remove any notifications for old pins
                // This was to fix a bug where removing a location would still leave its geofence
                for location in locations {
                    ProximityNotificationManager.shared.cancelNotifications(for: location)
                }
                
                // Schedule proximity notifications for each location
                for location in locations {
                    ProximityNotificationManager.shared.scheduleProximityNotification(for: location)
                }
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
                    
                    // Location Button with zoom level adjustment
                    Button {
                        if let userLocation = locationManager.userLocation {
                            // Center map to user location with a zoom level
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003) // Adjust the zoom level here
                        }
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                }
            }
            
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.description)
                            .font(.subheadline)
                        
                        Button("Close") {
                            withAnimation {
                                selectedLocation = nil
                            }
                        }
                        .font(.caption)
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .shadow(radius: 8)
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
            
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
        .sheet(isPresented: $showSheet) {
            Stories()
        }
        .sheet(isPresented: $showSettingsSheet) {
            Settings()
        }
        .animation(.easeInOut, value: selectedLocation)
    }
}

#Preview {
    MapView()
}

