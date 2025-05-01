//
//  MapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics
import CoreLocation

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
    
    // Quiz state
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false
    
    // Proximity check for quiz
    var isUserNearSelectedLocation: Bool {
        guard let selected = selectedLocation,
              let userLocation = locationManager.userLocation else {
            return false
        }
        let distance = userLocation.coordinate.distance(to: selected.coordinate)
        return distance < 50
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations) { location in
                
                MapAnnotation(coordinate: location.coordinate) {
                    Button {
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        withAnimation {
                            selectedLocation = location
                        }
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(location.visited == 1 ? .green : .red)
                            .shadow(radius: 2)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocation()
                locations = LocationLoader.loadLocations() // Load locations
                
                ProximityNotificationManager.shared.requestPermission()
                for location in locations {
                    ProximityNotificationManager.shared.cancelNotifications(for: location)
                    ProximityNotificationManager.shared.scheduleProximityNotification(for: location)
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation {
                    if !isMapInitialized {
                        mapRegion.center = newLocation.coordinate
                        isMapInitialized = true
                    }
                    
                    let userCoordinate = newLocation.coordinate
                    
                    // Update location visit state based on proximity
                    for index in locations.indices {
                        let locationCoord = locations[index].coordinate
                        let distance = locationCoord.distance(to: userCoordinate)
                        
                        if distance < 50 && locations[index].visited != 1 {
                            locations[index].visited = 1
                            AudioManager.playSound(soundName: "visited.wav", soundVol: 0.5)
                        }
                    }
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
                    
                    Button {
                        showEmergency = true
                        AudioManager.playSound(soundName: "siren.wav", soundVol: 0.5)
                    } label: {
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
                    
                    Button {
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
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
            
            // Location detail panel with quiz
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text(location.name)
                            .font(.headline)
                        Text(location.description)
                            .font(.subheadline)
                        
                        HStack {
                            Text("Visited:")
                                .font(.subheadline)
                                .bold()
                            Image(systemName: location.visited == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(location.visited == 1 ? .green : .red)
                                .font(.title3)
                        }
                        .padding(.top)
                        
                        // Show quiz only if the location is visited
                        if location.visited == 1 {
                            if let question = location.quizQuestion,
                               let answers = location.quizAnswers, let correctIndex = location.correctAnswerIndex {
                                
                                Text(question)
                                    .font(.headline)
                                    .padding(.top)
                                
                                ForEach(answers.indices, id: \.self) { index in
                                    Button {
                                        if index == correctIndex {
                                            isAnswerCorrect = true
                                            AudioManager.playSound(soundName: "correct.wav", soundVol: 0.5)
                                            // Mark quiz as completed and update the array
                                            if let selectedIndex = locations.firstIndex(where: { $0.id == location.id }) {
                                                locations[selectedIndex].quizCompleted = true
                                            }
                                        } else {
                                            isAnswerCorrect = false
                                            AudioManager.playSound(soundName: "wrong.wav", soundVol: 0.5)
                                        }
                                        isQuizFinished = true
                                    } label: {
                                        Text(answers[index])
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                                
                                if isQuizFinished {
                                    Text(isAnswerCorrect ? "That's right!" : "Oops, try again!")
                                        .font(.headline)
                                        .foregroundColor(isAnswerCorrect ? .green : .red)
                                        .padding()
                                        .transition(.opacity)
                                }
                            }
                        } else if location.visited == 0 {
                            // Display message if location is not yet visited
                            HStack {
                                Image(systemName: "location.slash")
                                    .foregroundColor(.orange)
                                Text("Get closer to the location to take the quiz!")
                                    .font(.footnote)
                                    .foregroundColor(.orange)
                            }
                            .padding(.top)
                        }
                        
                        Button("Close") {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
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
            
            // Emergency overlay
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
        .onChange(of: selectedLocation) { _ in
            isQuizFinished = false
            isAnswerCorrect = false
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

#Preview {
    MapView()
}
