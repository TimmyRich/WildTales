//
//  MapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

// This is the main map view, it is the one that will notify the user when they get close to a location and mark it as visited as well
// They can also do the quizzes when the go up to a location

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
    
    // where default map view is when no location (its brisbane city)
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003) // this part is just the zoom
    )
    
    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false
    
    @State private var selectedLocation: Location?
    
    // state of quiz for showing
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false

    var body: some View {
        ZStack {
            // map with user dot
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
                        Image(uiImage: UIImage(named: pinImageName(for: location)) ?? UIImage())
                            .resizable()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 2)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocation()
                locations = LocationLoader.loadLocations() // load locations
                
                // removes old ones and sets up a notification for each location on the map
                ProximityNotificationManager.shared.requestPermission()/*
                for location in locations {
                    ProximityNotificationManager.shared.cancelNotifications(for: location)
                    /*ProximityNotificationManager.shared.scheduleProximityNotification(for: location)*/
                }*/
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
                        // distance from user to map pin
                        let distance = locationCoord.distance(to: userCoordinate)
                        
                        // if distance is under 50m and isnt already visted it will mark it as visited and save with the addition of a sound effect
                        if distance < 50 && locations[index].visited != 1 {
                            let content = UNMutableNotificationContent()
                            content.title = "You're Close!"
                            content.body = "You're close to \(locations[index].name)"
                            content.sound = UNNotificationSound.default

                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                            let request = UNNotificationRequest(identifier: "noticication", content: content, trigger: trigger)

                            UNUserNotificationCenter.current().add(request) { error in
                                if let error = error {
                                    print("Error scheduling notification: \(error.localizedDescription)")
                                }
                            }
                            
                            locations[index].visited = 1
                            LocationLoader.saveLocations(locations)
                            AudioManager.playSound(soundName: "visited.wav", soundVol: 0.5)
                            
                            
                        }
                        
                        
                    }
                }
            }
            
            VStack {
                HStack {
                    
                    
                    Button { // back button goes to the previous page
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))

                    .shadow(radius: 5)
                    .padding(.leading, 30.0)
                    
                    Spacer()
                    
                    Button { // simply centers the map and zooms in to default
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
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                    
                    Spacer()
                    
                    // emergency button shows the emergency view overlay
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
            

            
            // location detail panel with quiz
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 12) {
                        Text(location.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        Text(location.description)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        HStack {
                            // visited shows if it has been visited or not
                            Text("Visited:")
                                .font(.subheadline)
                                .bold()
                            Image(systemName: location.visited == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(location.visited == 1 ? .green : .red)
                                .font(.title3)
                            
                           /* Text("Quiz:")
                                .font(.subheadline)
                                .bold()
                            Image(systemName: location.quizCompleted == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(location.quizCompleted == 1 ? .green : .red)
                                .font(.title3)*/
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                        
                        // users have to visit the location to view the quiz
                        if location.visited == 1 {
                            // initialise quiz question and answer text and correct index
                            if let question = location.quizQuestion,
                               let answers = location.quizAnswers,
                               let correctIndex = location.correctAnswerIndex {
                                
                                Text(question)
                                    .font(.headline)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                
                                ForEach(answers.indices, id: \.self) { index in
                                    Button {
                                        // check of the clicked index matches the correct index
                                        if index == correctIndex {
                                            isAnswerCorrect = true
                                            AudioManager.playSound(soundName: "correct.wav", soundVol: 0.5)
                                            
                                            // Mark quiz as completed and update the array
                                            if let selectedIndex = locations.firstIndex(where: { $0.id == location.id }) {
                                                locations[selectedIndex].quizCompleted = true
                                                LocationLoader.saveLocations(locations)
                                            }
                                        } else {
                                            // if the index does not match the correct one
                                            isAnswerCorrect = false
                                            AudioManager.playSound(soundName: "wrong.wav", soundVol: 0.5)
                                        }
                                        isQuizFinished = true
                                    } label: {
                                        Text(answers[index])
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.pink.opacity(0.1))
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                // if the quiz has been attempted, it will show the user if they got the asnwer wrong or right
                                // This just changes it depending on correct, colours included
                                if isQuizFinished {
                                    Text(isAnswerCorrect ? "That's right!" : "Oops, try again!") // colour change
                                        .font(.headline)
                                        .foregroundColor(isAnswerCorrect ? .green : .red)
                                        .padding()
                                        .transition(.opacity)
                                }
                            }
                        } else if location.visited == 0 {
                            
                            
                            if location.quizQuestion != nil {
                                HStack {
                                    Image(systemName: "dot.radiowaves.up.forward")
                                        .foregroundColor(.red)
                                    Text("Get closer to the location to take the quiz!")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                    
                                }
                                .padding(.top)
                                
                            }
                            // message if location is not yet visited
                            
                            else {
                                HStack {
                                    Image(systemName: "pencil.slash")
                                        .foregroundColor(.orange)
                                    Text("No quiz for this location!")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                    
                                }
                                .padding(.top)
                                
                            }
                            
                          
                        }
                        // closes the location map pin sheet
                        Button("Close") {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            withAnimation {
                                selectedLocation = nil
                            }
                        }
                        .font(.body)
                        //.fontWeight(.semibold)
                        .padding(.top, 6)
                        .frame(maxWidth: .infinity)
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
            GalleryView()
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
    
    func pinImageName(for location: Location) -> String {
        switch location.category {
        case .animal:
            return location.visited == 1 ? "map_animal" : "map_animal_blank"
        case .plant:
            return location.visited == 1 ? "map_plant" : "map_plant_blank"
        case .location:
            return location.visited == 1 ? "map_place" : "map_place_blank"
        }
    }

}

// small extention to calculate distance between two coordinates, courtesy (https://stackoverflow.com/questions/11077425/finding-distance-between-cllocationcoordinate2d-points/28683508)
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
