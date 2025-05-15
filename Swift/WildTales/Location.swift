//
//  NewLocation.swift
//  WildTales
//
//  Created by Kurt McCullough on 24/3/2025.
//

// Struct with the needed details of a location for the location JSON database

import CoreLocation
import Foundation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var visited: Int
    var quizQuestion: String?
    var quizAnswers: [String]?
    var correctAnswerIndex: Int?
    var quizCompleted: Bool
    var category: LocationCategory
    var zone: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    } //coordinate
}

// for each location category
enum LocationCategory: String, Codable, CaseIterable, Identifiable {
    case plant
    case animal
    case location
    case fence

    var id: String { self.rawValue }
}
