//
//  ContentView.swift
//  WildTales
//
//  Created by Kurt McCullough on 24/3/2025.
//

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct MapView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var mapRegion = MKCoordinateRegion(center: .init(latitude: 0, longitude: 0), span: .init(latitudeDelta: 0, longitudeDelta: 0))
    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
            .ignoresSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation {
                    mapRegion.center = newLocation.coordinate
                }
            }
            

            if let userLocation = locationManager.userLocation {
                Circle()
                    .fill(Color.red)
                    .opacity(0.7)
                    .frame(width: 20, height: 20)
                    .position(
                        x: CGFloat(mapRegion.center.longitude ),
                        y: CGFloat(mapRegion.center.latitude)
                    ).ignoresSafeArea(.all)
                   /*.animation(.easeInOut(duration: 0.5), value: userLocation.coordinate)*/
            }
            
            VStack {
                HStack {
                    Button {
                        appState.clickedGo = false
                    } label: {
                        Image(systemName: "arrowshape.backward")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                    
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        
                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                    .hapticOnTouch()
                    
                    Spacer()
                    
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "book")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                    .hapticOnTouch()
                    
                    Spacer()
                    
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                    .hapticOnTouch()
                }
            }
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
    MapView()
}
