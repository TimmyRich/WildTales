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


class BadgeLoader: ObservableObject {
    // store badges in this field
    @Published var data = [Badge]()

    init() {
        // call loadBadges whenever this object is initialised
        loadBadges()
    }
    
    private func getFileURL() -> URL? {
        let fileManager = FileManager.default
        guard let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docsDir.appendingPathComponent("Badges.json")
    }

    
    
    // getter for retrieving badges
    func getBadges() -> [Badge] {
        return self.data
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
    func saveBadges() { // New function to save updated badges
        guard let url = getFileURL() else { // Using the helper function to get the file URL
            print("Unable to find file URL for saving") // Print error if file URL is not found
            return
        }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Ensures JSON is pretty-printed
            let data = try encoder.encode(self.data) // Encode the updated badges array
            try data.write(to: url) // Write the encoded data to the file
        } catch {
            print("Failed to save badges: \(error)") // Print error if saving fails
        }
    }

    // Add a new badge and save to file
    func addBadge(_ badge: Badge) {
        self.data.append(badge) // Add badge to the array
        saveBadges()  // Save changes to JSON
    }
    
    // Remove a badge and save changes to file
    func removeBadge(_ badge: Badge) {
        if let index = self.data.firstIndex(where: { $0.id == badge.id }) { // Updated: Using firstIndex(where:) to find the index
            self.data.remove(at: index) // Remove badge by its index
            saveBadges()  // Save changes to JSON
        }
    }
    
    // Remove all badges that belong to the parentImage
    func removeAllBadges(parentImage: String) {
        self.data = self.data.filter{ badge in
            badge.parentImage != parentImage
        }
        saveBadges()
    }
    
    func updateBadgePosition(id: UUID, newPosition: CGPoint) {
        if let index = data.firstIndex(where: { $0.id == id }) {
            data[index].x = newPosition.x
            data[index].y = newPosition.y
            saveBadges()
        }
    }
}
