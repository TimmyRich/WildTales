//
//  CommunityMapView.swift
//  WildTales
//
//  Created by Kurt McCullough on 1/4/2025.
//

// Exactly the same as MapView but does not take a zone input and displays all pins from the locations JSON database.
//

import AVFoundation
import CoreHaptics
import CoreLocation
import MapKit
import SwiftUI

struct CommunityMapView: View {
    @State private var showGIF = true  // shows swipe gif by default on startup

    @Environment(\.presentationMode) var goBack  // to go back to map selection

    @State private var isShowingFullImage = false  //for full image on pin

    @State private var wikipediaImageURL: URL? = nil  // default wikipedia url to nothing

    @State private var showScreenTimeAlert = false  // for screen time alert
    @State private var screenTimerStart: Date? = nil  //start time for alert
    @State private var ScreenTimer: Timer? = nil  // timer count

    @State private var showEmergency = false  //to show the emergency popup
    @StateObject private var locationManager = LocationManager()

    // where default map view is when no location (its brisbane city)
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)  // this part is just the zoom
    )

    @State private var locations = [Location]()  // all locations
    @State private var isMapLoaded = false  // checks if map is initialised

    @State private var selectedLocation: Location?  //selected location for when pressed

    // state of quiz for showing
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false

    //filter rotation for swipable interface
    enum FilterCategory: String, CaseIterable {
        case all = "All"
        case animal = "Animals"
        case plant = "Plants"
        case location = "Locations"
    }

    @State private var selectedFilter: FilterCategory = .all  //default to all for filter

    var body: some View {
        ZStack {
            // map with user dot
            Map(  // most of thse variables are standard and autofill when createing a Map()
                coordinateRegion: $mapRegion,
                interactionModes: .all,  // allows all interactions with the map
                showsUserLocation: true,  // shows user location as blue dot
                userTrackingMode: .none,  // dont follow user
                annotationItems: locations.filter { location in  // show for each of the filter locations of present
                    switch selectedFilter {
                    case .all: return true
                    case .animal: return location.category == .animal
                    case .plant: return location.category == .plant
                    case .location: return location.category == .location
                    }
                }
            ) { location in  // eah location in the locations array is turned into a button and placed on the map
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                ) {
                    if location.category == .fence {  //fence is shown but not clickable
                        Image("House")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(radius: 2)
                    } else {
                        Button(action: {
                            withAnimation {
                                selectedLocation = location  // select this location for viewing
                                AudioManager.playSound(
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }
                        }) {
                            Image(
                                uiImage: UIImage(
                                    named: pinImageName(for: location)  // visited or uvisited map pin
                                ) ?? UIImage()  // default
                            )
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(radius: 2)
                        }
                    }
                }

            }
            .ignoresSafeArea()  // can go from corner to corner
            .onAppear {  // when view first shows up
                locationManager.requestLocation()  // request location if not previoously asked
                startScreenTimer()  // start screen on timer
                locations = LocationLoader.loadLocations()  //load locations

                ProximityNotificationManager.shared.requestPermission()  //request notification permission
                ProximityNotificationManager.shared.scheduleDailyNotification()
            }

            .onChange(of: locationManager.userLocation) { newLocation in  // when the users locations changes
                if let newLocation = newLocation {
                    if !isMapLoaded {  // when first initialised, center the screen to the user
                        mapRegion.center = newLocation.coordinate
                        isMapLoaded = true
                    }

                    let userCoordinate = newLocation.coordinate  //users location

                    //zones for badge notification, add here for all unique locations to get a badge for
                    let zonesOfInterest = [
                        "University of Queensland",
                        "Southbank Parklands",
                        "Botanical Gardens",
                        "Custom",
                    ]

                    //load locations
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

                    //checks if each zone has been completed
                    checkZoneCompletion(
                        zones: zonesOfInterest,
                        locations: allLocations
                    )

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
                        {  //setting up notofication content
                            let content = UNMutableNotificationContent()
                            content.title = "You're Too Far Away!"
                            content.body =
                                "Move closer home, you could be in danger!"
                            content.sound = UNNotificationSound.default

                            //time to trigger the notification
                            let trigger = UNTimeIntervalNotificationTrigger(
                                timeInterval: 1,  //one second
                                repeats: false
                            )

                            //when the notification is actioned
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
                            // siren sound constant
                            AudioManager.playSound(
                                soundName: "siren.wav",
                                soundVol: 0.5
                            )

                        }

                        // if distance is under 50m and isnt already visted it will mark it as visited and save with the addition of a sound effect
                        if distance < 50 && locations[index].visited != 1
                            && locations[index].category
                                != LocationCategory.fence
                        {  //notification content
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

                            //if user gets close and t isnt already bvisited, the pin will open automatically
                            UNUserNotificationCenter.current().add(request) {
                                (error) in
                                if let error = error {
                                    // Handle error if there is one
                                    print(
                                        "Error adding notification request: \(error.localizedDescription)"
                                    )
                                } else {
                                    selectedLocation = locations[index]  //if it work, just debugging
                                    print(
                                        "Notification request successfully added."
                                    )
                                }
                            }

                            //mark as visited
                            locations[index].visited = 1
                            var allLocations = LocationLoader.loadLocations()  //reload locations

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
                stopScreenTimer()  // when going off this view, stop the screen time timer
            }

            VStack {
                HStack {

                    Button {  // back button goes to the previous page
                        AudioManager.playSound(
                            soundName: "boing.wav",
                            soundVol: 0.5
                        )
                        goBack.wrappedValue.dismiss()  //go to previous view
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
                        showEmergency = true  // trigger emergency help
                        AudioManager.playSound(
                            soundName: "siren.wav",
                            soundVol: 0.5
                        )
                    } label: {
                        Image(systemName: "phone.connection.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.red))  //big red colour
                            .shadow(radius: 5)
                            .padding()
                    }
                }
                Spacer()
            }

            VStack {
                Spacer()
                HStack {

                    Image("Quokka_1")  //quokka image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: UIScreen.main.bounds.width / 6,  //dynamic
                            height: UIScreen.main.bounds.height / 6
                        )
                        .rotationEffect(.degrees(30))  //rotated a little
                        .ignoresSafeArea(.all)
                        .padding(.leading, 20.0)

                    Spacer()

                    ZStack {

                        TabView(selection: $selectedFilter) {  //swipable filter using a TabView to di it
                            ForEach(FilterCategory.allCases, id: \.self) {  // for each filter category
                                filter in
                                Text(filter.rawValue)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        Color("HunterGreen").opacity(0.8)
                                    )
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .padding(.horizontal, 30)
                                    .tag(filter)

                            }
                        }
                        .tabViewStyle(
                            PageTabViewStyle(indexDisplayMode: .never)  // dont have the white dots which is default to on
                        )
                        .frame(height: 70)

                    }

                    Button {  // simply centers the map and zooms in to default
                        if let userLocation = locationManager.userLocation {
                            mapRegion.center = userLocation.coordinate
                            mapRegion.span = MKCoordinateSpan(
                                latitudeDelta: 0.003,
                                longitudeDelta: 0.003  // default zoom when laoding in and clicking button
                            )
                        }
                        AudioManager.playSound(
                            soundName: "boing.wav",  //boing sound
                            soundVol: 0.5
                        )
                    } label: {
                        Image(systemName: "location.circle.fill")  //icon
                    }
                    .font(.system(size: 40))
                    .foregroundColor(Color("HunterGreen"))
                    .shadow(radius: 5)
                    .padding()
                }
            }.ignoresSafeArea()

            HStack {
                if showGIF {  //show swipe gif for ease of access
                    GIFView(gifName: "swipe")
                        .frame(width: 70, height: 70)
                        .padding(.top, UIScreen.main.bounds.height - 300)
                }
            }

            // location detail panel with quiz
            if let location = selectedLocation {  // for the selected location
                ZStack {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()

                    /*Button(action: {
                        selectedLocation = nil  // when X is clicked
                    }) {
                        Image("exitButtonWhite")
                            .resizable()
                            .frame(width: 80, height: 40)
                            .foregroundColor(.white)
                    
                            .padding()
                            //.background(Color("HunterGreen"))
                    }.simultaneousGesture(
                        TapGesture().onEnded {
                            AudioManager.playSound(
                                soundName: "boing.wav",
                                soundVol: 0.5
                            )
                        }
                    )
                    .padding(.trailing, UIScreen.main.bounds.width-150)
                    .padding(.bottom, UIScreen.main.bounds.height-250)*/

                    VStack(alignment: .center, spacing: 12) {
                        Button(action: {
                            selectedLocation = nil  // when X is clicked
                        }) {
                            Image("exitButton")
                                .resizable()
                                .frame(width: 60, height: 30)
                                .foregroundColor(.white)

                                .padding(.trailing, 190.0)
                                .padding(10.0)
                            //.background(Color("HunterGreen"))
                            //.frame(width: 60, height: 30)

                        }.simultaneousGesture(
                            TapGesture().onEnded {
                                AudioManager.playSound(
                                    soundName: "boing.wav",
                                    soundVol: 0.5
                                )
                            }
                        ).zIndex(1)

                        ZStack(alignment: .topTrailing) {

                            if let url = wikipediaImageURL {  //wikipedia image (if exists)
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:  //if no image use pawicon
                                        Image("PawIcon")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 150)
                                            .clipped()
                                            .cornerRadius(8)
                                    case .success(let image):  // if there is an imag, us ut
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 150)
                                            .clipped()
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                isShowingFullImage = true  // when clicked go to full screen image
                                            }
                                    case .failure:  //if there was a failure, use default (stopped it reusing old image on new pin)
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
                                        EmptyView()  //default, showulnt get to this
                                    }
                                }
                            } else {
                                Image("PawIcon")  // default again to paw icon, for errors where old images would show up
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipped()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        isShowingFullImage = true
                                    }
                            }

                            // this part is for redirecting to a wikipedia link for each pin
                            Button(action: {  // when clicking on the blue ?
                                let query =
                                    location.name.addingPercentEncoding(
                                        withAllowedCharacters: .urlQueryAllowed
                                    ) ?? ""
                                if let url = URL(  // search wikipeida with the location name as the query
                                    string:
                                        "https://en.wikipedia.org/wiki/\(query)"
                                ) {
                                    UIApplication.shared.open(url)  //go to the url in default browser
                                }
                            }) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("HunterGreen"))
                                    .padding(8)
                            }

                        }

                        Text(location.name)  //location details
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        Text(location.description)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        HStack {
                            Text("Visited:")  // if the place is visted
                                .font(.subheadline)
                                .bold()
                            Image(
                                systemName: location.visited == 1  // x if unvisited and tick if visited
                                    ? "checkmark.circle.fill"
                                    : "xmark.circle.fill"
                            )
                            .foregroundColor(
                                location.visited == 1 ? .green : .red
                            )  //green if visited and red if not
                            .font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)

                        if location.visited == 1 {  // if location has been visited, show quiz info
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
                                        if index == correctIndex {  // if correct, play sound and mark answer as correct
                                            isAnswerCorrect = true
                                            AudioManager.playSound(
                                                soundName: "correct.wav",
                                                soundVol: 0.5
                                            )
                                            if let selectedIndex =  // update array of the quiz is correct
                                                locations.firstIndex(where: {
                                                    $0.id == location.id
                                                })
                                            {
                                                locations[selectedIndex]
                                                    .quizCompleted = true  // mark as true
                                                var allLocations =
                                                    LocationLoader.loadLocations()  //reload locations
                                                for updated in locations {
                                                    if let index =
                                                        allLocations.firstIndex(
                                                            where: {
                                                                $0.id
                                                                    == updated
                                                                    .id
                                                            })
                                                    {
                                                        allLocations[index] =
                                                            updated
                                                    } else {
                                                        allLocations.append(
                                                            updated
                                                        )
                                                    }
                                                }
                                                LocationLoader.saveLocations(
                                                    allLocations  //save changes to locations
                                                )
                                            }
                                        } else {
                                            isAnswerCorrect = false  // if the answer is false
                                            AudioManager.playSound(
                                                soundName: "wrong.wav",  //incorrect sound
                                                soundVol: 0.5
                                            )
                                        }
                                        isQuizFinished = true  // marks quiz completed as true
                                    } label: {
                                        Text(answers[index])  // all the answers for the quiz's text
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                Color("HunterGreen").opacity(
                                                    0.1
                                                )
                                            )
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    }
                                }

                                if isQuizFinished {  //if the quiz has been attempted
                                    Text(
                                        isAnswerCorrect
                                            ? "That's right!"
                                            : "Oops, try again!"  // wrong or correct text
                                    )
                                    .font(.headline)
                                    .foregroundColor(
                                        isAnswerCorrect ? .green : .red  // wrong or correct text colours
                                    )
                                    .padding()
                                    .transition(.opacity)
                                }
                            }
                        }
                        if location.quizQuestion != nil && location.visited != 1
                        {  // if there is a quiz
                            HStack {
                                Image(systemName: "dot.radiowaves.up.forward")
                                    .foregroundColor(.red)
                                Text(
                                    "Get closer to the location to take the quiz!"  // say get closer to attampt
                                )
                                .font(.footnote)
                                .foregroundColor(.red)
                            }
                            .padding(.top)
                        } else if location.quizQuestion == nil {  // if there is not quiz question or quiz
                            HStack {
                                Image(systemName: "pencil.slash")
                                    .foregroundColor(.orange)
                                Text("No quiz for this location!")  // say there is no quiz for this location
                                    .font(.footnote)
                                    .foregroundColor(.orange)
                            }
                            .padding(.top)
                        }

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.white)  //background panel
                    )
                    .shadow(radius: 8)
                    .frame(maxWidth: 300)
                    .transition(.opacity)
                    .zIndex(100)
                    .onAppear {
                        fetchWikipediaImage(for: location.name)  // when appearing, attempt to get a image from wikipedia
                    }
                }
            }

            // Emergency overlay
            if showEmergency {
                ZStack {
                    ZStack {
                        Color.black.opacity(0.9)
                            .ignoresSafeArea()
                            .onTapGesture { showEmergency = false }

                        Emergency(showEmergency: $showEmergency)
                            .transition(.scale)
                    }.zIndex(1)
                }
            }

        }

        .fullScreenCover(isPresented: $isShowingFullImage) {  // when full screen image is selected
            ZStack {
                // Background color set to MapGreen
                Color.mapGreen.ignoresSafeArea()  // full screen background green colour

                if let url = wikipediaImageURL {  // show the wikipedia image
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

                // Close button
                VStack {
                    HStack {
                        Button(action: {
                            isShowingFullImage = false  // close the full screen view and go back to map
                        }) {
                            Image("exitButton")
                                .resizable()
                                .frame(width: 60, height: 30)
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(12)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }.onAppear {  // when map appears
            // Hide the GIF after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation {
                    showGIF = false
                }
            }
        }

        .animation(.easeInOut, value: selectedLocation)  // gif animation
        .onChange(of: selectedLocation) { _ in  // default for each location so going into it resets the quiz, but does not reset status in array
            isQuizFinished = false
            isAnswerCorrect = false
        }.preferredColorScheme(.light)  // always light mode map
        .alert(
            "You've been using the app for a while!",  //aleart for screen time
            isPresented: $showScreenTimeAlert
        ) {
            Button("Okay") {
                startScreenTimer()  // Reset timer when user acknowledges
            }
        } message: {
            Text("Time to take a break!")
        }

    }

    //different cases for the categories and the pins to show on the map
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

    //function to start the timer for screen time
    func startScreenTimer() {
        screenTimerStart = Date()
        ScreenTimer?.invalidate()  // Cancel previous timer if any

        ScreenTimer = Timer.scheduledTimer(
            withTimeInterval: 1600,
            repeats: false
        ) { _ in
            showScreenTimeAlert = true
        }
    }

    //stop the timer
    func stopScreenTimer() {
        ScreenTimer?.invalidate()
        ScreenTimer = nil
    }

    //loops through the locations and checks if the one is completed, if so awarding a badge and notifying about it
    func checkZoneCompletion(zones: [String], locations: [Location]) {
        for zone in zones {
            let locationsInZone = locations.filter { $0.zone == zone }  // check for the zone currently in
            let allVisited = locationsInZone.allSatisfy { $0.visited == 1 }  // if all are visit

            @State var notified = UserDefaults.standard.integer(forKey: zone)  // if not already notified

            if allVisited && notified != 1 {  // if all visited and not notified
                let content = UNMutableNotificationContent()

                UserDefaults.standard.set(1, forKey: zone)
                notified = 1  // Update the local state to reflect the change

                // set up notification ttext
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

                UNUserNotificationCenter.current().add(request) {  //error handling default autofil
                    error in
                    if let error = error {
                        print(
                            "Error scheduling notification: \(error.localizedDescription)"
                        )
                    }
                }

            } else if !allVisited && notified == 1 {  // if something in the array changes
                UserDefaults.standard.set(0, forKey: zone)
                notified = 0  // set to not notifiy so when they get them all again, it will re-show the badge
            }
        }
    }

    //basic function to get the firtst image wikipedia presents, takes a string and returns an imageURL

    // This was derived from ChatGPT with the promopt, "write some swift code that displays a wikipedia image based on a string input to it"
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
