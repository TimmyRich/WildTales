//
//  MapChoice.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct MapChoice: View {
    
    @EnvironmentObject var appState: AppState
    
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
            
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 300, height: 500)
                .cornerRadius(20)
            
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
    MapChoice()
}

