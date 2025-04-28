//
//  CreateMapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct CreateMapView: View {
    
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
    
    @State private var showLocationForm = false
    @State private var newLocationName = ""
    @State private var newLocationDescription = ""
    
    @State private var selectedLocation: Location?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    Button(action: {
                        withAnimation {
                            selectedLocation = location
                        }
                    }) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(location.visited == 1 ? .green : .red) // Color changes!
                            .shadow(radius: 2)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
                locations = LocationLoader.loadLocations()
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
            
            ZStack {
                Rectangle()
                    .frame(width: 1, height: 40)
                Rectangle()
                    .frame(width: 40, height: 1)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showLocationForm.toggle()
                    } label: {
                        Image(systemName: "plus")
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
                            mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                    })
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("Pink")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
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
            
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.description)
                            .font(.subheadline)
                        
                        Toggle(isOn: Binding(
                            get: { location.visited == 1 },
                            set: { newValue in
                                if let index = locations.firstIndex(where: { $0.id == location.id }) {
                                    locations[index].visited = newValue ? 1 : 0
                                    LocationLoader.saveLocations(locations)
                                    selectedLocation = locations[index]
                                }
                            }
                        )) {
                            Text("Visited")
                        }
                        .padding(.top)
                        
                        HStack {
                            Button("Remove") {
                                if let index = locations.firstIndex(where: { $0.id == location.id }) {
                                    locations.remove(at: index)
                                    LocationLoader.saveLocations(locations)
                                    selectedLocation = nil
                                }
                            }
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            
                            Spacer()
                            
                            Button("Close") {
                                withAnimation {
                                    selectedLocation = nil
                                }
                            }
                            .font(.caption)
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    .shadow(radius: 8)
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
        }
        .sheet(isPresented: $showSheet) {
            Stories()
        }
        .sheet(isPresented: $showSettingsSheet) {
            Settings()
        }
        .sheet(isPresented: $showLocationForm) {
            VStack {
                Text("New Location")
                    .font(.headline)
                    .padding()
                
                TextField("Enter name", text: $newLocationName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Enter description", text: $newLocationDescription)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Button("Save") {
                        let newLocation = Location(
                            id: UUID(),
                            name: newLocationName,
                            description: newLocationDescription,
                            latitude: mapRegion.center.latitude,
                            longitude: mapRegion.center.longitude,
                            visited: 0 // Set default visited
                        )
                        
                        locations.append(newLocation)
                        LocationLoader.saveLocations(locations)
                        newLocationName = ""
                        newLocationDescription = ""
                        showLocationForm = false
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Cancel") {
                        newLocationName = ""
                        newLocationDescription = ""
                        showLocationForm = false
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    CreateMapView()
}
