//
//  LocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 19/4/2025.
//

// help to load the locations from locations.json that stores all the locatons on device

import CoreLocation
import Foundation

class LocationLoader {
    static let fileName = "locations.json"  // create a file to store locations

    static let defaultLocations: [Location] = [
        // Southbank Parklands
        Location(
            id: UUID(),
            name: "Southbank Rainforest Walk",
            description:
                "Explore a lush subtropical rainforest in the heart of the city.",
            latitude: -27.4810,
            longitude: 153.0234,
            visited: 0,
            quizQuestion: "What type of forest is found here?",
            quizAnswers: ["Temperate", "Tropical", "Subtropical", "Boreal"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .plant,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Streets Beach",
            description: "A man-made beach along the Brisbane River.",
            latitude: -27.4796,
            longitude: 153.0235,
            visited: 0,
            quizQuestion: "What is unique about this beach?",
            quizAnswers: ["Saltwater", "Artificial", "Natural", "Tidal"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Nepalese Pagoda",
            description: "A hand-carved monument gifted from Nepal.",
            latitude: -27.4791,
            longitude: 153.0231,
            visited: 0,
            quizQuestion: "Which country gifted this pagoda?",
            quizAnswers: ["India", "China", "Nepal", "Thailand"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Epicurious Garden",
            description: "An edible community garden.",
            latitude: -27.4802,
            longitude: 153.0242,
            visited: 0,
            quizQuestion: "What can you do here?",
            quizAnswers: ["Swim", "Camp", "Pick herbs", "Ride a boat"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .plant,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Southbank Piazza",
            description: "A venue for live events and performances.",
            latitude: -27.4806,
            longitude: 153.0225,
            visited: 0,
            quizQuestion: "What happens here?",
            quizAnswers: ["Fishing", "Events", "Birdwatching", "Swimming"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Wheel of Brisbane",
            description: "A large observation wheel with city views.",
            latitude: -27.4769,
            longitude: 153.0219,
            visited: 0,
            quizQuestion: "What can you see from the top?",
            quizAnswers: [
                "Mountains", "Brisbane City", "Sydney Opera House", "Desert",
            ],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Arbour Walkway",
            description: "A floral pathway covered in bougainvillea.",
            latitude: -27.4783,
            longitude: 153.0230,
            visited: 0,
            quizQuestion: "Which flower covers the Arbour?",
            quizAnswers: ["Rose", "Bougainvillea", "Lavender", "Sunflower"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Riverside Green",
            description: "Open grassy space for play and events.",
            latitude: -27.4787,
            longitude: 153.0237,
            visited: 0,
            quizQuestion: "What is Riverside Green used for?",
            quizAnswers: [
                "Camping", "Swimming", "Events and picnics", "Shopping",
            ],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Southbank Playgrounds",
            description: "A fun play area for children.",
            latitude: -27.4794,
            longitude: 153.0241,
            visited: 0,
            quizQuestion: "Who uses this area the most?",
            quizAnswers: ["Adults", "Birds", "Children", "Cyclists"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),
        Location(
            id: UUID(),
            name: "Rainforest Amphitheatre",
            description: "Hidden stage surrounded by nature.",
            latitude: -27.4801,
            longitude: 153.0232,
            visited: 0,
            quizQuestion: "What happens at this spot?",
            quizAnswers: ["Weddings", "Swimming", "Performances", "Fishing"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Southbank Parklands"
        ),

        // University of Queensland
        Location(
            id: UUID(),
            name: "Great Court",
            description: "The iconic sandstone heart of UQ.",
            latitude: -27.4975,
            longitude: 153.0137,
            visited: 0,
            quizQuestion: "What is the Great Court known for?",
            quizAnswers: [
                "Libraries", "Shops", "Sandstone buildings", "Dormitories",
            ],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "UQ Lakes",
            description: "A serene spot for wildlife and walking.",
            latitude: -27.5002,
            longitude: 153.0152,
            visited: 0,
            quizQuestion: "Which animals are common here?",
            quizAnswers: ["Kangaroos", "Ducks", "Koalas", "Emus"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .animal,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "Biological Sciences Building",
            description: "Home to biology research and classes.",
            latitude: -27.4968,
            longitude: 153.0143,
            visited: 0,
            quizQuestion: "What is studied here?",
            quizAnswers: ["Law", "Biology", "Engineering", "History"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "UQ Art Museum",
            description: "Features contemporary exhibitions.",
            latitude: -27.4963,
            longitude: 153.0129,
            visited: 0,
            quizQuestion: "What is displayed here?",
            quizAnswers: ["Sculptures", "Art", "Cars", "Books"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "Physics Lawn",
            description: "Open grass space used by students.",
            latitude: -27.4972,
            longitude: 153.0148,
            visited: 0,
            quizQuestion: "What is commonly done here?",
            quizAnswers: ["Cooking", "Relaxing", "Swimming", "Climbing"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "Alumni Court",
            description: "A peaceful courtyard near sandstone buildings.",
            latitude: -27.4967,
            longitude: 153.0134,
            visited: 0,
            quizQuestion: "What is this area used for?",
            quizAnswers: ["Experiments", "Relaxation", "Cycling", "Parking"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "Central Library",
            description: "Main study and research library.",
            latitude: -27.4970,
            longitude: 153.0130,
            visited: 0,
            quizQuestion: "What can students do here?",
            quizAnswers: ["Cook", "Sleep", "Study", "Dance"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "UQ Union Complex",
            description: "Food, shops, and services for students.",
            latitude: -27.4973,
            longitude: 153.0138,
            visited: 0,
            quizQuestion: "What do students find here?",
            quizAnswers: ["Animals", "Food and shops", "Labs", "Classrooms"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "Forgan Smith Building",
            description: "Iconic sandstone law building.",
            latitude: -27.4960,
            longitude: 153.0135,
            visited: 0,
            quizQuestion: "What subject is taught here?",
            quizAnswers: ["Engineering", "Biology", "Law", "Music"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),
        Location(
            id: UUID(),
            name: "UQ Art Sculpture Trail",
            description: "Modern sculptures across campus.",
            latitude: -27.4959,
            longitude: 153.0142,
            visited: 0,
            quizQuestion: "What is displayed here?",
            quizAnswers: ["Graffiti", "Sculptures", "TVs", "Cars"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .location,
            zone: "University of Queensland"
        ),

        // Botanical Gardens (Mt Coot-tha)
        Location(
            id: UUID(),
            name: "Tropical Dome",
            description: "A climate-controlled greenhouse for exotic plants.",
            latitude: -27.4757,
            longitude: 152.9743,
            visited: 0,
            quizQuestion: "What grows inside the dome?",
            quizAnswers: ["Cacti", "Tropical plants", "Grasses", "Bamboo"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Japanese Garden",
            description: "A peaceful landscape garden gifted by Japan.",
            latitude: -27.4762,
            longitude: 152.9751,
            visited: 0,
            quizQuestion: "Who gifted this garden?",
            quizAnswers: ["Korea", "Japan", "China", "Vietnam"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Bonsai House",
            description: "Exhibits miniature potted trees.",
            latitude: -27.4759,
            longitude: 152.9738,
            visited: 0,
            quizQuestion: "What is displayed here?",
            quizAnswers: [
                "Palm trees", "Flowers", "Bonsai trees", "Succulents",
            ],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Fern House",
            description: "A collection of native and exotic ferns.",
            latitude: -27.4764,
            longitude: 152.9746,
            visited: 0,
            quizQuestion: "What type of plant is featured?",
            quizAnswers: ["Ferns", "Cacti", "Mosses", "Flowers"],
            correctAnswerIndex: 0,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Lagoon",
            description: "Water habitat surrounded by lush vegetation.",
            latitude: -27.4753,
            longitude: 152.9754,
            visited: 0,
            quizQuestion: "What can be seen here?",
            quizAnswers: [
                "Desert plants", "Water lilies", "Sand dunes", "Algae tanks",
            ],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Native Plant Section",
            description: "Collection of Australian native species.",
            latitude: -27.4752,
            longitude: 152.9748,
            visited: 0,
            quizQuestion: "Which plant type is featured?",
            quizAnswers: ["Foreign", "Native", "Cactus", "Seaweed"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Children’s Trail",
            description: "Interactive nature walk for young visitors.",
            latitude: -27.4756,
            longitude: 152.9759,
            visited: 0,
            quizQuestion: "Who is this trail for?",
            quizAnswers: ["Birds", "Students", "Children", "Researchers"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Cactus Garden",
            description: "Succulents and cacti from around the world.",
            latitude: -27.4760,
            longitude: 152.9762,
            visited: 0,
            quizQuestion: "Which plants are here?",
            quizAnswers: ["Ferns", "Cacti", "Trees", "Flowers"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Fragrant Plant Walk",
            description: "Aromatic plants line this peaceful path.",
            latitude: -27.4765,
            longitude: 152.9749,
            visited: 0,
            quizQuestion: "What is special about these plants?",
            quizAnswers: ["Color", "Smell", "Size", "Height"],
            correctAnswerIndex: 1,
            quizCompleted: false,
            category: .plant,
            zone: "Botanical Gardens"
        ),
        Location(
            id: UUID(),
            name: "Lookout Trail Start",
            description: "Entry to trail leading up to scenic views.",
            latitude: -27.4770,
            longitude: 152.9755,
            visited: 0,
            quizQuestion: "Where does this trail lead?",
            quizAnswers: ["Shopping mall", "Cave", "Lookout", "Farm"],
            correctAnswerIndex: 2,
            quizCompleted: false,
            category: .location,
            zone: "Botanical Gardens"
        ),

    ]

    // Tries to load a bunch of locations using JSON decoder
    static func loadLocations() -> [Location] {
        guard let url = getFileURL() else { return defaultLocations }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var savedLocations = try decoder.decode([Location].self, from: data)

            // If this is the first launch and there are no saved locations,
            // initialize with the defaults and save them.
            if savedLocations.isEmpty {
                saveLocations(defaultLocations)
                return defaultLocations
            }

            return savedLocations
        } catch {
            print("Error loading locations: \(error)")
            // On error (e.g., corrupt file), return defaults and overwrite file
            saveLocations(defaultLocations)
            return defaultLocations
        }
    }

    // Call when any changes are made to save the changes on the file
    static func saveLocations(_ locations: [Location]) {
        guard let url = getFileURL() else { return }

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(locations)
            try data.write(to: url)
        } catch {
            print("Failed to save locations: \(error)")
        }
    }

    static private func getFileURL() -> URL? {
        let fileManager = FileManager.default
        let directory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
        return directory?.appendingPathComponent(fileName)
    }
}
