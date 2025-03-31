import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct MapView: View {
    
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
                    isMapInitialized = true // Prevents further unwanted updates
                }
            }
            
            VStack {
                HStack {
                    
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                        Image("homeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .padding()
                            //.hapticOnTouch()
                    }
                    // Back Button
                    /*Button {
                        appState.clickedGo = false
                    } label: {
                        Image(systemName: "arrowshape.backward")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()*/

                    Spacer()
                    
                    // Center Map Button
                    Button {
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .padding()
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    // Add Location Button
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
                    
                    // Stories Button
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
                    
                    // Settings Button
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
