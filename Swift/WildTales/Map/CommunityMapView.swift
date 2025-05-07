import SwiftUI
import MapKit
import AVFoundation
import SpriteKit
import CoreHaptics
import CoreLocation

struct CommunityMapView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var goBack
    
    @State private var showEmergency = false
    @StateObject private var locationManager = LocationManager()
    
    // where default map view is when no location (its brisbane city)
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -27.4705, longitude: 153.0260),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10) // this part is just the zoom
    )
    
    @State private var showSheet = false
    @State private var showSettingsSheet = false
    @State private var isMapInitialized = false
    
    @State private var selectedLocation: Location?
    
    // state of quiz for showing
    @State private var isQuizFinished = false
    @State private var isAnswerCorrect = false
    
    @State private var locations = [
            Location(
                id: UUID(),
                name: "San Francisco City Center",
                description: "The heart of San Francisco",
                latitude: 37.7749,
                longitude: -122.4194,
                visited: 0,
                quizQuestion: "What is the capital of California?",
                quizAnswers: ["Los Angeles", "Sacramento", "San Francisco", "San Diego"],
                correctAnswerIndex: 1,
                quizCompleted: false,
                category: .location,
                zone: "SF Downtown"
            ),
            Location(
                id: UUID(),
                name: "Golden Gate Bridge",
                description: "A famous suspension bridge.",
                latitude: 37.8024,
                longitude: -122.4058,
                visited: 0,
                quizQuestion: "What year was the Golden Gate Bridge completed?",
                quizAnswers: ["1929", "1937", "1941", "1950"],
                correctAnswerIndex: 1,
                quizCompleted: false,
                category: .location,
                zone: "SF Bay Area"
            ),
            Location(
                id: UUID(),
                name: "Alcatraz Island",
                description: "Former prison island, now a tourist destination.",
                latitude: 37.8199,
                longitude: -122.4783,
                visited: 0,
                quizQuestion: "Which famous criminal was held in Alcatraz?",
                quizAnswers: ["Al Capone", "John Dillinger", "George 'Machine Gun' Kelly", "Richard Ramirez"],
                correctAnswerIndex: 0,
                quizCompleted: false,
                category: .location,
                zone: "SF Bay Area"
            ),
            Location(
                id: UUID(),
                name: "Fisherman's Wharf",
                description: "A popular tourist destination.",
                latitude: 37.8070,
                longitude: -122.4750,
                visited: 0,
                quizQuestion: "Which sea creature is most commonly seen around Fisherman's Wharf?",
                quizAnswers: ["Sharks", "Sea Lions", "Dolphins", "Turtles"],
                correctAnswerIndex: 1,
                quizCompleted: false,
                category: .location,
                zone: "SF Waterfront"
            ),
            Location(
                id: UUID(),
                name: "Union Square",
                description: "A large public plaza in downtown San Francisco.",
                latitude: 37.7846,
                longitude: -122.4068,
                visited: 0,
                quizQuestion: "Which company’s headquarters are located near Union Square?",
                quizAnswers: ["Apple", "Google", "Twitter", "Tesla"],
                correctAnswerIndex: 2,
                quizCompleted: false,
                category: .location,
                zone: "SF Downtown"
            ),
        ]
    
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
            Map(coordinateRegion: $mapRegion,
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
               
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    if location.category == .fence {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                            .shadow(radius: 2)
                    } else {
                        Button(action: {
                            withAnimation {
                                selectedLocation = location
                            }
                        }) {
                            Image(uiImage: UIImage(named: pinImageName(for: location)) ?? UIImage())
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
                
                ProximityNotificationManager.shared.requestPermission()
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
                        
                        //if the location is a fence and they go past 500 meters of it
                        if locations[index].category == LocationCategory.fence && distance > 500{
                            let content = UNMutableNotificationContent()
                            content.title = "You're Too Far Away!"
                            content.body = "Move closer home, you could be in danger!"
                            content.sound = UNNotificationSound.default

                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                            let request = UNNotificationRequest(identifier: "noticication", content: content, trigger: trigger)

                            UNUserNotificationCenter.current().add(request) { error in
                                if let error = error {
                                    print("Error scheduling notification: \(error.localizedDescription)")
                                }
                            }
                            
                            AudioManager.playSound(soundName: "siren.wav", soundVol: 0.5)
                            
                            
                            
                            
                        }
                        
                        // if distance is under 50m and isnt already visted it will mark it as visited and save with the addition of a sound effect
                        if distance < 50 && locations[index].visited != 1 && locations[index].category != LocationCategory.fence {
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
                            var allLocations = LocationLoader.loadLocations()
                            for updated in locations {
                                if let index = allLocations.firstIndex(where: { $0.id == updated.id }) {
                                    allLocations[index] = updated
                                } else {
                                    allLocations.append(updated)
                                }
                            }
                            LocationLoader.saveLocations(allLocations)
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
                        Text("Visited:")
                            .font(.subheadline)
                            .bold()
                        Image(systemName: location.visited == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(location.visited == 1 ? .green : .red)
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                    if location.visited == 1 {
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
                                    if index == correctIndex {
                                        isAnswerCorrect = true
                                        AudioManager.playSound(soundName: "correct.wav", soundVol: 0.5)
                                        if let selectedIndex = locations.firstIndex(where: { $0.id == location.id }) {
                                            locations[selectedIndex].quizCompleted = true
                                            var allLocations = LocationLoader.loadLocations()
                                            for updated in locations {
                                                if let index = allLocations.firstIndex(where: { $0.id == updated.id }) {
                                                    allLocations[index] = updated
                                                } else {
                                                    allLocations.append(updated)
                                                }
                                            }
                                            LocationLoader.saveLocations(allLocations)
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
                                        .background(Color.pink.opacity(0.1))
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
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
                    } else {
                        if location.quizQuestion != nil {
                            HStack {
                                Image(systemName: "dot.radiowaves.up.forward")
                                    .foregroundColor(.red)
                                Text("Get closer to the location to take the quiz!")
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
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                        withAnimation {
                            selectedLocation = nil
                        }
                    }
                    .font(.body)
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .shadow(radius: 8)
                .frame(maxWidth: 300)
                .transition(.opacity)
                .zIndex(100)
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

            VStack{
                Spacer()
                HStack{
                    
                    Image("Quokka_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.height / 6)
                        .rotationEffect(.degrees(30))
                        .ignoresSafeArea(.all)
                        .padding(.leading, 20.0)
                    
                    
                    
                    Spacer()
                    
                    
                    TabView(selection: $selectedFilter) {
                        ForEach(FilterCategory.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                                .font(.headline)
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
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color("HunterGreen").opacity(0.8)))
                    .shadow(radius: 5)
                    .padding()
                    .hapticOnTouch()
                }
            }.ignoresSafeArea()


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
        case .fence:
            return location.visited == 1 ? "blank" : "blank"
        }
    }

}


#Preview {
    CommunityMapView()
}
