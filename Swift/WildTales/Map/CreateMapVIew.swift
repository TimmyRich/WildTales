//
//  CreateMapVIew.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

// This page allows the user to create pins on the map.

// Pressing the plus will add a location to the middle of the screen.
// It then prompts the user for a name, description, and quiz elements of the map.
// Each location is stored with a unique ID.
//
// Pressing the home icon creates a fence which user cannot go outside of 500 meters of this
//
// Clicking on pre-exisint icon allows it to be removed or visited/univisted
// Quiz can also be tested on this

import AVFoundation  //sound managers
import CoreHaptics  //haptics when needed
import MapKit  // maps API
import SwiftUI  // ui

struct CreateMapView: View {

    @Environment(\.presentationMode) var goBack  // to go back to previous view

    @State private var showEmergency = false  // variable for if emergency is showing

    @StateObject private var locationManager = LocationManager()  // this helps load the locations from the json in addition to adding and saving to the arrays

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )  // default zoom into brisbane when loading map

    @State private var locations = [Location]()  //to hold locations

    @State private var showSettingsSheet = false  // to show shetting view
    @State private var isMapLoaded = false  //see if map has loaded

    @State private var showLocationForm = false  // if a location has been pressed or not

    // variables to be overwritten later for forms
    @State private var newLocationName = ""
    @State private var newLocationDescription = ""
    @State private var quizQuestion = ""
    @State private var quizAnswers = ["", "", "", ""]
    @State private var correctAnswerIndex: Int? = nil

    //if its a animal, plant, location or fence
    @State private var selectedCategory: LocationCategory = .location

    //default zone to show only custom pins
    @State private var selectedZone = "Custom"

    //for which location is clicked
    @State private var selectedLocation: Location?

    // if the quiz is finished or answers for quiz has been found
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false

    var body: some View {
        ZStack {
            // this is the map initialization
            Map(
                coordinateRegion: $mapRegion,
                interactionModes: .all,  //allow user to interact in many ways
                showsUserLocation: true,  // user location
                userTrackingMode: .none,  //doesnt follow the user
                annotationItems: locations  //pins on the map
            ) { location in  // for each location
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                ) {
                    Button(action: {
                        withAnimation {
                            selectedLocation = location  // each pin is a button and when clicks makes it the selected location
                        }
                    }) {
                        if location.category == .fence {  // if the category is special fence, show it as a house
                            Image(
                                "House"
                            ).resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.red)
                                .shadow(radius: 2)
                        } else {  // otherwise show it as visited or unvisited normal icons
                            Image(
                                uiImage: UIImage(
                                    named: pinImageName(for: location)  // visited or univisited image
                                ) ?? UIImage()
                            )
                            .resizable()
                            .frame(width: 40, height: 40)  // pin size on map
                            .shadow(radius: 2)
                        }
                    }
                }

            }

            .ignoresSafeArea(.all)
            .onAppear {  //when the map appears
                locationManager.requestLocation()  //request the users location (if not already done)
                let allLocations = LocationLoader.loadLocations()  //loads locations onto map
                locations = allLocations.filter {
                    $0.zone == "Custom"  // only show locations where the zone is "custom"
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in  //when loading in, center map and initialise it
                if let newLocation = newLocation, !isMapLoaded {
                    mapRegion.center = newLocation.coordinate  //centers map
                    isMapLoaded = true
                }
            }

            VStack {  // top meny elemtns, back and emergency
                HStack {
                    Button {  // back button to go to map views
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss()  //dismiss this view and go to the previous
                    } label: {
                        Image(systemName: "chevron.left")  //symbol for <
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
                    .shadow(radius: 5)
                    .padding(.leading, 30.0)
                    .hapticOnTouch()

                    Spacer()

                    Button(action: {  // emergency button
                        showEmergency = true  // show the emergency popup
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
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
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
                            zone: "Custom"

                        )
                        locations.append(newFence)  // add fence to locations array
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
                        Image(systemName: "house.fill")
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Button {  // center location
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(  //default zoom too
                                latitudeDelta: 0.005,
                                longitudeDelta: 0.005
                            )
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")  //location symbol
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }
                    )
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()

                    Button {  // setting menu
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        showSettingsSheet.toggle()  // show settings view
                    } label: {
                        Image(systemName: "gear")  // settings icon
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                }
            }
            .overlay(  // if the show emergency is true
                Group {
                    if showEmergency {  // this just toggles the emergency menu if the button has been pressed
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture { showEmergency = false }  // background, if background is pressed the view goes away

                            Emergency(showEmergency: $showEmergency)
                                .transition(.scale)  // small animation as suggested by Co-Pilot
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
                                    isQuizFinished = true  // sets quiz completion to true
                                }) {
                                    Text(answers[index])  //display the answers text
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            Color("HunterGreen").opacity(0.1)
                                        )
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
                                            newValue ? 1 : 0  // switch it over to the other value
                                        var allLocations =
                                            LocationLoader.loadLocations()  // loads locations

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
                    .foregroundColor(Color("HunterGreen"))
                    .padding()
                }
                .transition(.move(edge: .bottom))
            }
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

                    TextField("Enter name", text: $newLocationName)  //name text
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    TextField(
                        "Enter description",
                        text: $newLocationDescription  //description text
                    )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(
                            LocationCategory.allCases.filter { $0 != .fence }
                        ) { category in
                            Text(category.rawValue.capitalized).tag(category)  // retrieved from (https://developer.apple.com/documentation/swiftui/picker) as part of a dynamic picker for categories
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())  //so they can only choose between 3 options, excluding fence
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Text("Quiz Question")
                        .font(.headline)

                    TextField("Enter question", text: $quizQuestion)  //save quiz question text
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
                                        ? Color("HunterGreen") : .gray
                                )
                                .imageScale(.large)
                                .padding(.leading, 8)
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        Button(action: {  // save location button
                            let newLocation = Location(
                                //gather field data and let all location information equal that
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

                            // add it to the array of locations
                            locations.append(newLocation)

                            // reload the map with the new location
                            var allLocations = LocationLoader.loadLocations()

                            //if it already exisits, update it, otherwise add new one
                            for updated in locations {
                                if let index = allLocations.firstIndex(where: {
                                    $0.id == updated.id
                                }) {
                                    allLocations[index] = updated  // pre-exisintg
                                } else {
                                    allLocations.append(updated)  // add new
                                }
                            }

                            LocationLoader.saveLocations(allLocations)
                            // save locations

                            //reset everything to blank
                            newLocationName = ""
                            newLocationDescription = ""
                            quizQuestion = ""
                            quizAnswers = ["", "", "", ""]
                            selectedCategory = .location
                            correctAnswerIndex = nil
                            showLocationForm = false
                            selectedZone = "Custom"
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("HunterGreen"))
                                .cornerRadius(10)
                                .contentShape(Rectangle())  // Ensures the entire padded area is tappable
                        }
                        .padding(.horizontal)

                        Button(action: {  // when cancelled, reset values to nothing
                            newLocationName = ""
                            newLocationDescription = ""
                            quizQuestion = ""
                            quizAnswers = ["", "", "", ""]
                            selectedCategory = .location
                            correctAnswerIndex = nil
                            showLocationForm = false
                            selectedZone = "Custom"  // custom map pins zone will always be "Custom"
                        }) {
                            Text("Cancel")  // cancel text formatting
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }.preferredColorScheme(.light)  //map is alwsys on light mode

    }

    // gives a location, searched if it is visited, if it is, the normal icon, otherwise blank version
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
