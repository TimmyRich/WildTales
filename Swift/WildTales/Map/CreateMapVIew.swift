//
//  CreateMapVIew.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

// This page allows the user to create pins on the map.
// Pressing the plus will add a location to the middle of the screen.
// It then prompts the user for a name, description, and quiz elements of the map.
// None of these elements are as each location is stored with a unique ID

import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics

struct CreateMapView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack
    
    @State private var showEmergency = false
    
    @StateObject private var locationManager = LocationManager() // this helps load the locations from the json in addition to adding and saving to the arrays
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )
    
    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false
    
    // variables to be overqritten later for forms
    @State private var showLocationForm = false
    @State private var newLocationName = ""
    @State private var newLocationDescription = ""
    @State private var quizQuestion = ""
    @State private var quizAnswers = ["", "", "", ""]
    @State private var correctAnswerIndex: Int? = nil
    
    @State private var selectedLocation: Location?
    
    // quiz stuff for later
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false
    
    var body: some View {
        ZStack {
            // this is the map initialisation
            Map(coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    Button(action: {
                        withAnimation {
                            selectedLocation = location // each location map pin is a button, when pressed, the selected location is the one pressed on
                        }
                    }) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(location.visited == 1 ? .green : .red)
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
                    Button { // back button to go to map views
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
                    
                    Button(action: { // emergency button
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
            
            ZStack { // crosshairs in the middle of the screen for point accuracy
                Rectangle()
                    .frame(width: 1, height: 40)
                Rectangle()
                    .frame(width: 40, height: 1)
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button { // add button
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        showLocationForm.toggle() // shows up the form to add location
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
                    
                    Button { // for later additions
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
                    
                    Button { // center location
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
                    
                    Button { // setting menu
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
                    if showEmergency { // this just toggles the emergency menu if the button has been pressed
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
            
            // this is if a location has been selected (map pin pressed)
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(location.name).font(.headline) // gets location name and desciption
                        Text(location.description).font(.subheadline)
                        
                        // gets location quiz parts
                        if let question = location.quizQuestion,
                           let answers = location.quizAnswers,
                           let correctIndex = location.correctAnswerIndex {

                            // displays the quiz info
                            Text(question).font(.headline).padding(.top)
                            ForEach(answers.indices, id: \.self) { index in
                                Button(action: {
                                    // check for correct answer and what not
                                    if index == correctIndex {
                                        isAnswerCorrect = true
                                        AudioManager.playSound(soundName: "correct.wav", soundVol: 0.5)
                                        if let i = locations.firstIndex(where: { $0.id == location.id }) {
                                            // says if the quiz has successfully been completed (used later)
                                            if !locations[i].quizCompleted {
                                                locations[i].quizCompleted = true
                                                LocationLoader.saveLocations(locations)
                                                selectedLocation = locations[i]
                                            }
                                        }
                                    } else {
                                        // if the answer selected is wrong)
                                        isAnswerCorrect = false
                                        AudioManager.playSound(soundName: "wrong.wav", soundVol: 0.5)
                                    }
                                    isQuizFinished = true
                                }) {
                                    Text(answers[index])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.pink.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }

                        // if the quiz has been attempted, a right or wrong will show
                        if isQuizFinished {
                            Text(isAnswerCorrect ? "That's right!" : "Oops, try again!")
                                .font(.headline)
                                .foregroundColor(isAnswerCorrect ? .green : .red)
                                .padding()
                                .transition(.opacity)
                        }
                        
                        // This is the visited toggle, it can change if the location has been visited or not then save it to the array
                        Toggle("Visited", isOn: Binding(
                            get: { location.visited == 1 },
                            set: { newValue in
                                if let index = locations.firstIndex(where: { $0.id == location.id }) {
                                    locations[index].visited = newValue ? 1 : 0
                                    LocationLoader.saveLocations(locations)
                                    selectedLocation = locations[index]
                                }
                            }
                        ))

                        // this toggle hasnt been finished yet
                        Toggle("Quiz Completed", isOn: Binding(
                            get: { location.quizCompleted },
                            set: { _ in }
                        ))
                        .disabled(true)

                        HStack {
                            // This button removes the location by ID then updates the array
                            Button("Remove") {
                                if let index = locations.firstIndex(where: { $0.id == location.id }) {
                                    locations.remove(at: index)
                                    LocationLoader.saveLocations(locations)
                                    selectedLocation = nil
                                }
                            }
                            .foregroundColor(.red)

                            Spacer()

                            // removes selected location so nothing shows
                            Button("Close") {
                                withAnimation {
                                    selectedLocation = nil
                                    isQuizFinished = false
                                }
                            }
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
                //input text fields for user input
                Text("New Location").font(.headline).padding()
                TextField("Enter name", text: $newLocationName) // save name
                    .padding().textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Enter description", text: $newLocationDescription) // save description
                    .padding().textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Quiz Question")
                TextField("Enter question", text: $quizQuestion) // save question title
                    .padding().textFieldStyle(RoundedBorderTextFieldStyle())

                ForEach(0..<4, id: \.self) { i in
                    HStack {
                        TextField("Answer \(i + 1)", text: $quizAnswers[i]) // save the answers
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            correctAnswerIndex = i // gets the index from a button to the right of the aswwer boxes
                        }) {
                            Image(systemName: correctAnswerIndex == i ? "largecircle.fill.circle" : "circle") // fills the correct answer fill when selcted
                        }
                    }.padding(.horizontal)
                }
                
                HStack {
                    Button("Save") { // this button appands to the array the location info when clicking save, it then resets the variables so they can be changed again for adding a ewn location
                        let newLocation = Location(
                            id: UUID(),
                            name: newLocationName,
                            description: newLocationDescription,
                            latitude: mapRegion.center.latitude,
                            longitude: mapRegion.center.longitude,
                            visited: 0,
                            quizQuestion: quizQuestion.isEmpty ? nil : quizQuestion,
                            quizAnswers: quizAnswers.contains(where: { !$0.isEmpty }) ? quizAnswers : nil,
                            correctAnswerIndex: correctAnswerIndex,
                            quizCompleted: false
                        )
                        // reset variables so they can be changed again
                        locations.append(newLocation)
                        LocationLoader.saveLocations(locations)
                        newLocationName = ""
                        newLocationDescription = ""
                        quizQuestion = ""
                        quizAnswers = ["", "", "", ""]
                        correctAnswerIndex = nil
                        showLocationForm = false
                    }
                    .padding()
                    
                    Spacer()
                    
                    // resets variabels when cancelled
                    Button("Cancel") {
                        newLocationName = ""
                        newLocationDescription = ""
                        quizQuestion = ""
                        quizAnswers = ["", "", "", ""]
                        correctAnswerIndex = nil
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
