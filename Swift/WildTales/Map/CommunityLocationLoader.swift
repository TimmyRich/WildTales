//
//  CommunityLocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//

import Foundation

class CommunityLocationLoader {
    static func loadLocations() -> [Location] {
        // Try loading from the saved file in Documents directory
        if let url = getFileURL(), FileManager.default.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode([Location].self, from: data)
            } catch {
                print("Failed to load from Documents directory: \(error)")
            }
        }

        // Fallback: Load from bundled locations.json
        if let bundleURL = Bundle.main.url(forResource: "MapLocations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: bundleURL)
                let decoder = JSONDecoder()
                return try decoder.decode([Location].self, from: data)
            } catch {
                print("Failed to load bundled locations.json: \(error)")
            }
        }

        return []
    }
    
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
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("MapLocaitions")
    }

}
