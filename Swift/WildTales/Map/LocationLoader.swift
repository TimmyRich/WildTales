//
//  LocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 19/4/2025.
//

import Foundation

class LocationLoader {
    static let fileName = "locations.json" // create a file to store locations
    
    // tries to load a bunch of locations using json decoder
    static func loadLocations() -> [Location] {
        guard let url = getFileURL() else { return [] }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let locations = try decoder.decode([Location].self, from: data)
            return locations
        } catch {
            return []
        }
    }
    
    // addds the locations to the json file using json encoder
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
        return directory?.appendingPathComponent(fileName)
    }
}


