//
//  CommunityMapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

// This view has not been changed mutch, it just is a basic view of the map and doesnt show any pins yet. The MapLocations are the pins that need to be preloaded onto this map.

import AVFoundation
import CoreHaptics
import MapKit
import SpriteKit
import SwiftUI

struct CommunityMapView: View {

    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack

    @State private var isShowingFullImage = false

    @State private var wikipediaImageURL: URL? = nil

    @State private var showUsageAlert = false
    @State private var usageStartTime: Date? = nil
    @State private var usageTimer: Timer? = nil

    @State private var showEmergency = false
    @StateObject private var locationManager = LocationManager()

    // where default map view is when no location (its brisbane city)
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)  // this part is just the zoom
    )

    @State private var locations = [Location]()
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false

    @State private var selectedLocation: Location?

    // state of quiz for showing
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false

    enum FilterCategory: String, CaseIterable {
        case all = "All"
        case animal = "Animals"
        case plant = "Plants"
        case location = "Locations"
    }

    @State private var selectedFilter: FilterCategory = .all

    var body: some View {
        ZStack {
            // map with user dot
            Map(
                coordinateRegion: $mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: locations.filter { location in
                    switch selectedFilter {
                    case .all: return true
                    case .animal: return location.category == .animal
                    case .plant: return location.category == .plant
                    case .location: return location.category == .location
                    }
                }
            ) { location in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                ) {
                    if location.category == .fence {
                        Image("House")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(radius: 2)
                    } else {
                        Button(action: {
                            withAnimation {
                                selectedLocation = location
                            }
                        }) {
                            Image(
                                uiImage: UIImage(
                                    named: pinImageName(for: location)
                                ) ?? UIImage()
                            )
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(radius: 2)
                        }
                    }
                }

            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocation()
                startUsageTimer()
                locations = LocationLoader.loadLocations()

                ProximityNotificationManager.shared.requestPermission()
            }

            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation {
                    if !isMapInitialized {
                        mapRegion.center = newLocation.coordinate
                        isMapInitialized = true
                    }

                    let userCoordinate = newLocation.coordinate

                    /*let zonesOfInterest = [
                        "University of Queensland",
                        "Southbank Parklands",
                        "Botanical Gardens",
                        "Custom"
                    ]

                    var allLocations = LocationLoader.loadLocations()

                    // Update the locations efficiently
                    for updated in locations {
                        if let index = allLocations.firstIndex(where: {
                            $0.id == updated.id
                        }) {
                            allLocations[index] = updated
                        } else {
                            allLocations.append(updated)
                        }
                    }

                    checkZoneCompletion(
                        zones: zonesOfInterest,
                        locations: allLocations
                    )*/

                    // Update location visit state based on proximity
                    for index in locations.indices {
                        let locationCoord = locations[index].coordinate
                        // distance from user to map pin
                        let distance = locationCoord.distance(
                            to: userCoordinate
                        )

                        //if the location is a fence and they go past 500 meters of it
                        if locations[index].category == LocationCategory.fence
                            && distance > 500
                        {
                            let content = UNMutableNotificationContent()
                            content.title = "You're Too Far Away!"
                            content.body =
                                "Move closer home, you could be in danger!"
                            content.sound = UNNotificationSound.default

                            let trigger = UNTimeIntervalNotificationTrigger(
                                timeInterval: 1,
                                repeats: false
                            )

                            let request = UNNotificationRequest(
                                identifier: "noticication",
                                content: content,
                                trigger: trigger
                            )

                            UNUserNotificationCenter.current().add(request) {
                                error in
                                if let error = error {
                                    print(
                                        "Error scheduling notification: \(error.localizedDescription)"
                                    )
                                }
                            }

                            AudioManager.playSound(
                                soundName: "siren.wav",
                                soundVol: 0.5
                            )

                        }

                        // if distance is under 50m and isnt already visted it will mark it as visited and save with the addition of a sound effect
                        if distance < 50 && locations[index].visited != 1
                            && locations[index].category
                                != LocationCategory.fence
                        {
                            let content = UNMutableNotificationContent()
                            content.title = "You're Close!"
                            content.body =
                                "You're close to \(locations[index].name)"
                            content.sound = UNNotificationSound.default

                            let trigger = UNTimeIntervalNotificationTrigger(
                                timeInterval: 1,
                                repeats: false
                            )

                            let request = UNNotificationRequest(
                                identifier: "noticication",
                                content: content,
                                trigger: trigger
                            )

                            UNUserNotificationCenter.current().add(request) {
                                error in
                                if let error = error {
                                    print(
                                        "Error scheduling notification: \(error.localizedDescription)"
                                    )
                                }
                            }

                            locations[index].visited = 1
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

                            LocationLoader.saveLocations(allLocations)
                            AudioManager.playSound(
                                soundName: "visited.wav",
                                soundVol: 0.5
                            )

                        }

                    }
                }
            }
            .onDisappear {
                stopUsageTimer()
            }

            VStack {
                HStack {

                    Button {  // back button goes to the previous page
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))

                    .shadow(radius: 5)
                    .padding(.leading, 30.0)

                    Spacer()

                    Spacer()

                    // emergency button shows the emergency view overlay
                    Button {
                        showEmergency = true
                        AudioManager.playSound(
                            soundName: "siren.wav",
                            soundVol: 0.5
                        )
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
                VStack(alignment: .center, spacing: 12) {
                    ZStack(alignment: .topTrailing) {
                        if let url = wikipediaImageURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    Image("PawIcon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            isShowingFullImage = true
                                        }
                                case .failure:
                                    Image("PawIcon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            isShowingFullImage = true
                                        }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image("PawIcon")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(8)
                                .onTapGesture {
                                    isShowingFullImage = true
                                }
                        }

                        Button(action: {
                            let query =
                                location.name.addingPercentEncoding(
                                    withAllowedCharacters: .urlQueryAllowed
                                ) ?? ""
                            if let url = URL(
                                string: "https://en.wikipedia.org/wiki/\(query)"
                            ) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(8)
                        }
                    }

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
                        Text("Visited:")
                            .font(.subheadline)
                            .bold()
                        Image(
                            systemName: location.visited == 1
                                ? "checkmark.circle.fill" : "xmark.circle.fill"
                        )
                        .foregroundColor(location.visited == 1 ? .green : .red)
                        .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                    if location.visited == 1 {
                        if let question = location.quizQuestion,
                            let answers = location.quizAnswers,
                            let correctIndex = location.correctAnswerIndex
                        {

                            Text(question)
                                .font(.headline)
                                .padding(.top)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            ForEach(answers.indices, id: \.self) { index in
                                Button {
                                    if index == correctIndex {
                                        isAnswerCorrect = true
                                        AudioManager.playSound(
                                            soundName: "correct.wav",
                                            soundVol: 0.5
                                        )
                                        if let selectedIndex =
                                            locations.firstIndex(where: {
                                                $0.id == location.id
                                            })
                                        {
                                            locations[selectedIndex]
                                                .quizCompleted = true
                                            var allLocations =
                                                LocationLoader.loadLocations()
                                            for updated in locations {
                                                if let index =
                                                    allLocations.firstIndex(
                                                        where: {
                                                            $0.id == updated.id
                                                        })
                                                {
                                                    allLocations[index] =
                                                        updated
                                                } else {
                                                    allLocations.append(updated)
                                                }
                                            }
                                            LocationLoader.saveLocations(
                                                allLocations
                                            )
                                        }
                                    } else {
                                        isAnswerCorrect = false
                                        AudioManager.playSound(
                                            soundName: "wrong.wav",
                                            soundVol: 0.5
                                        )
                                    }
                                    isQuizFinished = true
                                } label: {
                                    Text(answers[index])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color("HunterGreen").opacity(0.1))
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }

                            if isQuizFinished {
                                Text(
                                    isAnswerCorrect
                                        ? "That's right!" : "Oops, try again!"
                                )
                                .font(.headline)
                                .foregroundColor(
                                    isAnswerCorrect ? .green : .red
                                )
                                .padding()
                                .transition(.opacity)
                            }
                        }
                    } else {
                        if location.quizQuestion != nil {
                            HStack {
                                Image(systemName: "dot.radiowaves.up.forward")
                                    .foregroundColor(.red)
                                Text(
                                    "Get closer to the location to take the quiz!"
                                )
                                .font(.footnote)
                                .foregroundColor(.red)
                            }
                            .padding(.top)
                        } else {
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

                    Button("Close") {
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        withAnimation {
                            selectedLocation = nil
                        }
                    }
                    .font(.body)
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity)

                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.white)
                )
                .shadow(radius: 8)
                .frame(maxWidth: 300)
                .transition(.opacity)
                .zIndex(100)
                .onAppear {
                    fetchWikipediaImage(for: location.name)
                }
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

            VStack {
                Spacer()
                HStack {

                    Image("Quokka_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: UIScreen.main.bounds.width / 6,
                            height: UIScreen.main.bounds.height / 6
                        )
                        .rotationEffect(.degrees(30))
                        .ignoresSafeArea(.all)
                        .padding(.leading, 20.0)

                    Spacer()

                    TabView(selection: $selectedFilter) {
                        ForEach(FilterCategory.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("HunterGreen").opacity(0.8))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                                .padding(.horizontal, 30)
                                .tag(filter)

                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 70)
                    .padding(.bottom, 10)

                    Button {  // simply centers the map and zooms in to default
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(
                                latitudeDelta: 0.003,
                                longitudeDelta: 0.003
                            )
                        }
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle().fill(Color("HunterGreen").opacity(0.8))
                    )
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                }
            }.ignoresSafeArea()

        }
        .sheet(isPresented: $showSheet) {
            GalleryView()
        }
        .fullScreenCover(isPresented: $isShowingFullImage) {
            ZStack {
                // Background color set to MapGreen
                Color.mapGreen.ignoresSafeArea()

                if let url = wikipediaImageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("PawIcon")  // Default image if no Wikipedia image
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                }

                // Close button in the top-left corner with HunterGreen background
                VStack {
                    HStack {
                        Button(action: {
                            isShowingFullImage = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(12)  // Adds space around the X icon
                                .background(Color.hunterGreen)  // HunterGreen background
                                .clipShape(Circle())  // Makes the button round
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }

        .sheet(isPresented: $showSettingsSheet) {
            Settings()
        }
        .animation(.easeInOut, value: selectedLocation)
        .onChange(of: selectedLocation) { _ in
            isQuizFinished = false
            isAnswerCorrect = false
        }.preferredColorScheme(.light)
        .alert(
            "You've been using the app for a while!",
            isPresented: $showUsageAlert
        ) {
            Button("Okay") {
                startUsageTimer()  // Reset timer when user acknowledges
            }
        } message: {
            Text("Time to take a break!")
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
        case .fence:
            return location.visited == 1 ? "blank" : "blank"
        }
    }

    func startUsageTimer() {
        usageStartTime = Date()
        usageTimer?.invalidate()  // Cancel previous timer if any

        usageTimer = Timer.scheduledTimer(
            withTimeInterval: 1800,
            repeats: false
        ) { _ in
            showUsageAlert = true
        }
    }

    func stopUsageTimer() {
        usageTimer?.invalidate()
        usageTimer = nil
    }

    /*
    func checkZoneCompletion(zones: [String], locations: [Location]) {
        for zone in zones {
            let locationsInZone = locations.filter { $0.zone == zone }
            let allVisited = locationsInZone.allSatisfy { $0.visited == 1 }

            if allVisited {
                let content = UNMutableNotificationContent()
                content.title = "You Have Earned A Badge!"
                content.body =
                    "Go into the gallery to see what you have recieved"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 1,
                    repeats: false
                )

                let request = UNNotificationRequest(
                    identifier: "noticication",
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request) {
                    error in
                    if let error = error {
                        print(
                            "Error scheduling notification: \(error.localizedDescription)"
                        )
                    }
                }

            }
        }
    }*/

    func fetchWikipediaImage(for title: String) {
        // Reset the image to nil so the previous one is cleared immediately
        DispatchQueue.main.async {
            self.wikipediaImageURL = nil
        }

        let query =
            title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ?? ""
        guard
            let url = URL(
                string:
                    "https://en.wikipedia.org/api/rest_v1/page/summary/\(query)"
            )
        else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                let result = try? JSONDecoder().decode(
                    WikipediaSummary.self,
                    from: data
                ),
                let imageUrlString = result.thumbnail?.source,
                let imageUrl = URL(string: imageUrlString)
            else { return }

            DispatchQueue.main.async {
                self.wikipediaImageURL = imageUrl
            }
        }.resume()
    }
}

#Preview {
    CommunityMapView()
}
