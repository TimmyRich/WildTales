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

import AVFoundation
import CoreHaptics
import MapKit
import SpriteKit
import SwiftUI

struct CreateMapView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack

    @State private var showEmergency = false

    @StateObject private var locationManager = LocationManager()  // this helps load the locations from the json in addition to adding and saving to the arrays

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )

    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false

    // variables to be overwritten later for forms
    @State private var showLocationForm = false
    @State private var newLocationName = ""
    @State private var newLocationDescription = ""
    @State private var quizQuestion = ""
    @State private var quizAnswers = ["", "", "", ""]
    @State private var correctAnswerIndex: Int? = nil

    @State private var selectedCategory: LocationCategory = .location

    @State private var selectedZone = "Custom"

    @State private var selectedLocation: Location?

    // quiz stuff for later
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false

    var body: some View {
        ZStack {
            // this is the map initialization
            Map(
                coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations
            ) { location in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                ) {
                    Button(action: {
                        withAnimation {
                            selectedLocation = location
                        }
                    }) {
                        if location.category == .fence {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.system(size: 28))
                                .foregroundColor(.red)
                                .shadow(radius: 2)
                        } else {
                            Image(
                                uiImage: UIImage(
                                    named: pinImageName(for: location)
                                ) ?? UIImage()
                            )
                            .resizable()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 2)
                        }
                    }
                }

            }

            .ignoresSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
                let allLocations = LocationLoader.loadLocations()
                locations = allLocations.filter { $0.zone == "Custom" }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation, !isMapInitialized {
                    mapRegion.center = newLocation.coordinate
                    isMapInitialized = true
                }
            }

            VStack {
                HStack {
                    Button {  // back button to go to map views
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Spacer()

                    Button(action: {  // emergency button
                        showEmergency = true
                        AudioManager.playSound(
                            soundName: "siren.wav",
                            soundVol: 0.5
                        )
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

            ZStack {  // crosshairs in the middle of the screen for point accuracy
                Rectangle()
                    .frame(width: 1, height: 40)
                Rectangle()
                    .frame(width: 40, height: 1)
            }

            VStack {
                Spacer()

                HStack {
                    Button {  // add button
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        showLocationForm.toggle()  // shows up the form to add location
                    } label: {
                        Image(systemName: "plus")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Button {
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )

                        // Remove existing fence if any
                        locations.removeAll { $0.category == .fence }

                        // Create and add new fence
                        let newFence = Location(
                            id: UUID(),
                            name: "Geofence",
                            description:
                                "An alarm will ring if your child isn't within 500 meters of this pin.",
                            latitude: mapRegion.center.latitude,
                            longitude: mapRegion.center.longitude,
                            visited: 0,
                            quizQuestion: nil,
                            quizAnswers: nil,
                            correctAnswerIndex: nil,
                            quizCompleted: false,

                            category: .fence,
                            zone: "Custom",

                        )
                        locations.append(newFence)
                        var allLocations = LocationLoader.loadLocations()

                        // Update the locations efficiently
                        for updated in locations {
                            if let index = allLocations.firstIndex(where: {
                                $0.id == updated.id
                            }) {
                                // If location exists, update it
                                allLocations[index] = updated
                            } else {
                                // Otherwise, append the new location
                                allLocations.append(updated)
                            }
                        }

                        // Save the updated locations back
                        LocationLoader.saveLocations(allLocations)
                    } label: {
                        Image(systemName: "person.2.wave.2.fill")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Button {  // center location
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(
                                latitudeDelta: 0.005,
                                longitudeDelta: 0.005
                            )
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }
                    )
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Button {  // setting menu
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color("HunterGreen")))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                }
            }
            .overlay(
                Group {
                    if showEmergency {  // this just toggles the emergency menu if the button has been pressed
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
                        Text(location.name).font(.headline)  // gets location name and description
                        Text(location.description).font(.subheadline)

                        // gets location quiz parts
                        if let question = location.quizQuestion,
                            let answers = location.quizAnswers,
                            let correctIndex = location.correctAnswerIndex
                        {

                            // displays the quiz info
                            Text(question).font(.headline).padding(.top)
                            ForEach(answers.indices, id: \.self) { index in
                                Button(action: {
                                    // check for correct answer and what not
                                    if index == correctIndex {
                                        isAnswerCorrect = true
                                        AudioManager.playSound(
                                            soundName: "correct.wav",
                                            soundVol: 0.5
                                        )
                                        if let i = locations.firstIndex(where: {
                                            $0.id == location.id
                                        }) {
                                            // says if the quiz has successfully been completed (used later)
                                            if !locations[i].quizCompleted {
                                                locations[i].quizCompleted =
                                                    true
                                                var allLocations =
                                                    LocationLoader.loadLocations()

                                                // Update the locations efficiently
                                                for updated in locations {
                                                    if let index =
                                                        allLocations.firstIndex(
                                                            where: {
                                                                $0.id
                                                                    == updated
                                                                    .id
                                                            })
                                                    {
                                                        // If location exists, update it
                                                        allLocations[index] =
                                                            updated
                                                    } else {
                                                        // Otherwise, append the new location
                                                        allLocations.append(
                                                            updated
                                                        )
                                                    }
                                                }

                                                // Save the updated locations back
                                                LocationLoader.saveLocations(
                                                    allLocations
                                                )
                                                selectedLocation = locations[i]
                                            }
                                        }
                                    } else {
                                        // if the answer selected is wrong)
                                        isAnswerCorrect = false
                                        AudioManager.playSound(
                                            soundName: "wrong.wav",
                                            soundVol: 0.5
                                        )
                                    }
                                    isQuizFinished = true
                                }) {
                                    Text(answers[index])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.pink.opacity(0.1))
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                        }

                        // if the quiz has been attempted, a right or wrong will show
                        if isQuizFinished {
                            Text(
                                isAnswerCorrect
                                    ? "That's right!" : "Oops, try again!"
                            )
                            .font(.headline)
                            .foregroundColor(isAnswerCorrect ? .green : .red)
                            .padding()
                            .transition(.opacity)
                        }

                        // This is the visited toggle, it can change if the location has been visited or not then save it to the array
                        Toggle(
                            "Visited",
                            isOn: Binding(
                                get: { location.visited == 1 },
                                set: { newValue in
                                    if let index = locations.firstIndex(where: {
                                        $0.id == location.id
                                    }) {
                                        locations[index].visited =
                                            newValue ? 1 : 0
                                        var allLocations =
                                            LocationLoader.loadLocations()

                                        // Update the locations efficiently
                                        for updated in locations {
                                            if let index =
                                                allLocations.firstIndex(where: {
                                                    $0.id == updated.id
                                                })
                                            {
                                                // If location exists, update it
                                                allLocations[index] = updated
                                            } else {
                                                // Otherwise, append the new location
                                                allLocations.append(updated)
                                            }
                                        }

                                        // Save the updated locations back
                                        LocationLoader.saveLocations(
                                            allLocations
                                        )
                                        selectedLocation = locations[index]
                                    }
                                }
                            )
                        )

                        // this toggle hasn't been finished yet
                        Toggle(
                            "Quiz Completed",
                            isOn: Binding(
                                get: { location.quizCompleted },
                                set: { _ in }
                            )
                        )
                        .disabled(true)

                        HStack {
                            // This button removes the location by ID then updates the array
                            Button("Remove") {
                                if let index = locations.firstIndex(where: {
                                    $0.id == location.id
                                }) {
                                    // Remove location from locations array
                                    locations.remove(at: index)

                                    // Load all locations from persistent storage
                                    var allLocations =
                                        LocationLoader.loadLocations()

                                    // Remove the location from allLocations as well
                                    if let allIndex = allLocations.firstIndex(
                                        where: { $0.id == location.id })
                                    {
                                        allLocations.remove(at: allIndex)
                                    }

                                    // Save the updated allLocations back to persistent storage
                                    LocationLoader.saveLocations(allLocations)

                                    // Deselect the location
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
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.white)
                    )
                    .shadow(radius: 8)
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
        }
        .sheet(isPresented: $showSheet) {
            GalleryView()
        }
        .sheet(isPresented: $showSettingsSheet) {
            Settings()
        }
        .sheet(isPresented: $showLocationForm) {
            ScrollView {  // some of the stuff didnt show on the screen so made it scrollable so they keyboards nots in they way
                VStack(spacing: 16) {
                    Text("New Location")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    TextField("Enter name", text: $newLocationName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    TextField(
                        "Enter description",
                        text: $newLocationDescription
                    )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(
                            LocationCategory.allCases.filter { $0 != .fence }
                        ) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Text("Quiz Question")
                        .font(.headline)

                    TextField("Enter question", text: $quizQuestion)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // for each of the answers possible
                    ForEach(0..<4, id: \.self) { i in
                        HStack {
                            TextField("Answer \(i + 1)", text: $quizAnswers[i])
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)

                            Button(action: {
                                correctAnswerIndex = i
                            }) {
                                Image(
                                    systemName: correctAnswerIndex == i
                                        ? "largecircle.fill.circle" : "circle"
                                )
                                .foregroundColor(
                                    correctAnswerIndex == i
                                        ? Color("Pink") : .gray
                                )
                                .imageScale(.large)
                                .padding(.leading, 8)
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        Button("Save") {
                            let newLocation = Location(
                                id: UUID(),
                                name: newLocationName,
                                description: newLocationDescription,
                                latitude: mapRegion.center.latitude,
                                longitude: mapRegion.center.longitude,
                                visited: 0,
                                quizQuestion: quizQuestion.isEmpty
                                    ? nil : quizQuestion,
                                quizAnswers: quizAnswers.contains(where: {
                                    !$0.isEmpty
                                }) ? quizAnswers : nil,
                                correctAnswerIndex: correctAnswerIndex,
                                quizCompleted: false,
                                category: selectedCategory,
                                zone: selectedZone
                            )

                            locations.append(newLocation)
                            var allLocations = LocationLoader.loadLocations()

                            // Update the locations efficiently
                            for updated in locations {
                                if let index = allLocations.firstIndex(where: {
                                    $0.id == updated.id
                                }) {
                                    // If location exists, update it
                                    allLocations[index] = updated
                                } else {
                                    // Otherwise, append the new location
                                    allLocations.append(updated)
                                }
                            }

                            // Save the updated locations back
                            LocationLoader.saveLocations(allLocations)
                            newLocationName = ""
                            newLocationDescription = ""
                            quizQuestion = ""
                            quizAnswers = ["", "", "", ""]
                            selectedCategory = .location
                            correctAnswerIndex = nil
                            showLocationForm = false
                            selectedZone = "Custom"

                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Pink"))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Button("Cancel") {
                            newLocationName = ""
                            newLocationDescription = ""
                            quizQuestion = ""
                            quizAnswers = ["", "", "", ""]
                            selectedCategory = .location
                            correctAnswerIndex = nil
                            showLocationForm = false
                            selectedZone = "Custom"

                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
        }.preferredColorScheme(.light)

    }

    func pinImageName(for location: Location) -> String {
        switch location.category {
        case .animal:
            return location.visited == 1 ? "map_animal" : "map_animal_blank"
        case .plant:
            return location.visited == 1 ? "map_plant" : "map_plant_blank"
        case .location:
            return location.visited == 1 ? "map_place" : "map_place_blank"
        case .fence:
            return location.visited == 1 ? "blank" : "blank"
        }
    }
}

#Preview {
    CreateMapView()
}
