//
//  Badge.swift
//  WildTales
//
//  Created by Timothy Richens-Gray on 30/4/2025.
//

import Foundation
import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let imageName: String
    var position: CGPoint
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
}

