//
//  LocationLoader.swift
//  WildTales
//
//  Created by Kurt McCullough on 19/4/2025.
//

import Foundation

struct LocationLoader {
    static func loadLocations() -> [Location] {
        guard let url = Bundle.main.url(forResource: "MapLocations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load map location data.")
            return []
        }

        do {
            let decoded = try JSONDecoder().decode([Location].self, from: data)
            return decoded
        } catch {
            print("Error decoding map locations: \(error)")
            return []
        }
    }
}

