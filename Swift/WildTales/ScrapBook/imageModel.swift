//
//  imageModel.swift
//  WildTales
//
//  Created by Yujie Wei on 2025/4/30.
//  
/*
import Foundation

struct ImageItem: Identifiable {
    let id = UUID()
    let imageName: String
    let locationTitle: String
    let description: String
}

let sampleImageList: [ImageItem] = [
    ImageItem(imageName:"displayImage1", locationTitle: "Near Lake", description: "I remember walking in the quiet place that morning—the air was crisp, birdsong echoed between the trees, and everything felt alive."),
    ImageItem(imageName:"displayImage2", locationTitle: "In Forest", description: "We sat near the creek where the water whispered over the rocks. It was peaceful sound of nature."),
    ImageItem(imageName:"displayImage3", locationTitle: "At Park", description: "We took a break from daily routine and visited the nearby park. The air was fresh and filled with the scent of grass."),
]
*/

import SwiftUI
import UIKit

struct ImageItem: Identifiable {
    let id = UUID()
    var uiImage: UIImage? = nil
    var imageName: String? = nil
    let locationTitle: String
    let description: String

    var displayImage: Image {
        if let uiImg = uiImage {
            return Image(uiImage: uiImg)
        } else if let name = imageName {
            return Image(name)
        }
        return Image(systemName: "photo.fill") 
    }
}

let sampleImageList: [ImageItem] = [
    ImageItem(imageName:"displayImage1", locationTitle: "Near Lake", description: "I remember walking..."),
    ImageItem(imageName:"displayImage2", locationTitle: "In Forest", description: "We sat near the creek..."),
    ImageItem(imageName:"displayImage3", locationTitle: "At Park", description: "We took a break..."),
]

