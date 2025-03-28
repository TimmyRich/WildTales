//
//  NewLocation.swift
//  WildTales
//
//  Created by Kurt McCullough on 24/3/2025.
//


import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    
}
