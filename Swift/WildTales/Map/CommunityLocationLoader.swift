//
//  CommunityLocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//

import Foundation

class CommunityLocationLoader {
    static let fileName = "MapLocations.json" // your JSON file name

    // Load bundled locations from the app bundle
    static func loadLocations() -> [Location] {
        guard let url = Bundle.main.url(forResource: "MapLocations", withExtension: "json") else {
            print("MapLocations.json not found in bundle")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let locations = try decoder.decode([Location].self, from: data)
            return locations
        } catch {
            print("Failed to decode MapLocations.json: \(error)")
            return []
        }
    }

    // Save locations to user's documents folder if you want to support editing
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

    // Save location data to documents directory (for edits)
    static private func getFileURL() -> URL? {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(fileName)
    }
}
