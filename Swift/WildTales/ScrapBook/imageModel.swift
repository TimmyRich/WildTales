//
//  imageModel.swift
//  WildTales
//
//  Created by Yujie Wei on 2025/4/30.
//  It defines the data model and includes sampleImageList for scrapbook image carousel
//  This data structure is revised according to ScrapBookPopup code derived from google gemini with prompt "for this page, we want to allow user to select photo from album, and then display the image in the Carousel.".

import SwiftUI
import UIKit


struct ImageItem: Identifiable, Codable {
    let id: UUID
    var imageData: Data?
    var imageName: String?
    let locationTitle: String
    let description: String

    var uiImage: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }

    var displayImage: Image {
        if let data = imageData, let img = UIImage(data: data) {
            return Image(uiImage: img)
        } else if let name = imageName {
            return Image(name)
        }
        return Image(systemName: "photo.fill")
    }

    // Initializer for new images
    // The following code is edited according to AI response with prompt: "how can I edit my code so that when user select photos and display them, the photo will be stored in the data structure. In this way,  I want my application can save all the selected photos. And even the app is terminated or closed, when user open the app again, they will see the newly added photos in the gallery."
    init(id: UUID = UUID(), uiImage: UIImage, locationTitle: String, description: String) {
        self.id = id
        // Convert UIImage to Data for persistent storage.
        self.imageData = uiImage.pngData()
        self.imageName = nil
        self.locationTitle = locationTitle
        self.description = description
    }

    // Initializer for images
    init(id: UUID = UUID(), imageName: String, locationTitle: String, description: String) {
        self.id = id
        self.imageData = nil
        self.imageName = imageName
        self.locationTitle = locationTitle
        self.description = description
    }
}


// Function manages the array of `ImageItem` objects, it saves the image list in JSON format.
class ImageStore {
    static let shared = ImageStore()
    private let imagesKey = "storedScrapbookImages_v1" // Key for UserDefaults

    private init() {}

    func saveImages(_ images: [ImageItem]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(images)
            UserDefaults.standard.set(data, forKey: imagesKey)
        } catch {
            print("Error in saving")
        }
    }

    func loadImages() -> [ImageItem] {
        guard let data = UserDefaults.standard.data(forKey: imagesKey) else {
            return sampleImageList
        }

        do {
            let decoder = JSONDecoder()
            let images = try decoder.decode([ImageItem].self, from: data)
            return images
        } catch {
            print("Error in loading")
            return sampleImageList
        }
    }
}
// End AI assisted coding


// Default data of image list
let sampleImageList: [ImageItem] = [
    ImageItem(
        imageName: "displayImage1",
        locationTitle: "Near Lake",
        description:
            "I remember walking in the quiet place that morning—the air was crisp, birdsong echoed between the trees, and everything felt alive."
    ),
    ImageItem(
        imageName: "displayImage2",
        locationTitle: "In Forest",
        description:
            "We sat near the creek where the water whispered over the rocks. It was peaceful sound of nature."
    ),
    ImageItem(
        imageName: "displayImage3",
        locationTitle: "At Park",
        description:
            "We took a break from daily routine and visited the nearby park. The air was fresh and filled with the scent of grass."
    ),
]




