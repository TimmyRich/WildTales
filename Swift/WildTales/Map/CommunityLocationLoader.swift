//
//  CommunityLocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 7/5/2025.
//

import Foundation

class CommunityLocationLoader {
    
    static func loadLocations() -> [Location] {
        guard let url = Bundle.main.url(forResource: "CommunityLocations", withExtension: "json") else {
            print("Error: Could not find CommunityLocations.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let locations = try decoder.decode([Location].self, from: data)
            return locations
        } catch {
            print("Error: Could not decode CommunityLocations.json, \(error)")
            return []
        }
    }
    
    static func saveLocations(_ locations: [Location]) {
        guard let url = Bundle.main.url(forResource: "CommunityLocations", withExtension: "json") else {
            print("Error: Could not find CommunityLocations.json")
            return
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(locations)
            try data.write(to: url)
        } catch {
            print("Error: Could not save CommunityLocations.json, \(error)")
        }
    }
}

