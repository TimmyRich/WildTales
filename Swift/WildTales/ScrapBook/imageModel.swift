//
//  imageModel.swift
//  WildTales
//
//  Created by Yujie Wei on 2025/4/30.
//  
 
import Foundation

struct ImageItem: Identifiable {
    let id = UUID()
    let imageName: String
    let locationTitle: String
    let description: String
}

let sampleImageList: [ImageItem] = [
    ImageItem(imageName:"scrapbookpic1", locationTitle: "At Forest", description: "I remember walking through the quiet forest that morning—the air was crisp, birdsong echoed between the trees, and everything felt alive."),
    ImageItem(imageName:"scrapbookpic2", locationTitle: "At City", description: "It was a bustling night in the city, the streets alive with movement and color."),
    ImageItem(imageName:"scrapbookpic3", locationTitle: "Near Silent Creek", description: "We sat near the creek where the water whispered over the rocks. It was peaceful sound of nature."),
    ImageItem(imageName:"scrapbookpic4", locationTitle: "Near Mountain and WaterFall", description: "That view took my breath away—the waterfall crashing down from the cliffs, mist rising in the sunlight."),
]


