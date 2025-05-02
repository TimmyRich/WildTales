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
    ImageItem(imageName:"scrapbookpic1", locationTitle: "At Tropical Dome", description: "one one one one one one one one one one one one one one one"),
    ImageItem(imageName:"scrapbookpic2", locationTitle: "Location2", description: "two two two two two two two two two two"),
    ImageItem(imageName:"scrapbookpic3", locationTitle: "Location3", description: "three three three three three three three three three"),
]


