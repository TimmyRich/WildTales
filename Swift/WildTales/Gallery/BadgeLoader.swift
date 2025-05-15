/*
 -- Acknowledgements --
 
 The BadgeLoader class was originally adapted from code provided by https://www.youtube.com/watch?v=G9vXr41ssdM
 which details how to load JSON data from a json file in the app bundle. This code was
 then adapted to work with JSON data formatted to to be decodable into a Badge struct
 which I defined. I prompted ChatGPT to extend this class by implementing a saveBadges
 function which I did by providing the stub for the saveBadges func and commenting the
 functionality I wanted. I then used the changes made by ChatGPT to implement the rest
 of the class.
 */

import Foundation
import SwiftUI

// badge model
struct Badge: Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case imageName
        case scale
        case degrees
        case x
        case y
        case parentImage
    }

    var id = UUID()
    var imageName: String
    var scale: Double = 0.13
    var degrees: Double = 0.0
    var x: Double = 0.0  // X position in points
    var y: Double = 0.0  // Y position in points
    var parentImage: String

    var rotation: Angle {
        Angle(degrees: degrees)
    }

    var position: CGPoint {
        CGPoint(x: x, y: y)
    }
}

/*
 BadgeLoader class
 */
class BadgeLoader: ObservableObject {
    // store badges in this field
    @Published var data = [Badge]()

    init() {
        // call loadBadges whenever this object is initialised
        loadBadges()
    }
    
    // Get the file url where Badge data is being stored
    private func getFileURL() -> URL? {
        let fileManager = FileManager.default
        guard let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docsDir.appendingPathComponent("Badges.json")
    }
    
    func loadBadges() {
        guard let url = getFileURL() else { // Updated: using new helper function getFileURL()
            // Print error message if file not found
            print("Badges.json not found")
            return
        }
        
        // Try to load badges
        do {
            // "data" gets raw JSON data from file
            let data = try Data(contentsOf: url)
            // badges gets decoded data from "data"
            let badges = try JSONDecoder().decode([Badge].self, from: data) // decode data of type "[Badge].self" from the variable "data"
            self.data = badges
        } catch {
            // print error message if JSON data couldn't be loaded or decoded
            print("Failed to load badges: \(error)") // Updated: more detailed error info
            self.data = []
        }
    }
    
    // Save updated badges back to JSON file
    func saveBadges() {
        guard let url = getFileURL() else {
            print("Unable to find file URL for saving")
            return
        }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self.data)
            try data.write(to: url)
        } catch {
            print("Failed to save badges: \(error)") // Print error if saving fails
        }
    }

    // Add a new badge and save to file
    func addBadge(_ badge: Badge) {
        self.data.append(badge)
        saveBadges()
    }
    
    // Remove a badge and save changes to file
    func removeBadge(_ badge: Badge) {
        if let index = self.data.firstIndex(where: { $0.id == badge.id }) {
            self.data.remove(at: index)
            saveBadges()
        }
    }
    
    // Remove all badges that belong to the parentImage
    func removeAllBadges(parentImage: String) {
        self.data = self.data.filter{ badge in
            badge.parentImage != parentImage
        }
        saveBadges()
    }
}
