//
//  Haptics.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import SwiftUI
import UIKit

struct HapticOnTouch: ViewModifier {
    @State var isDragging: Bool = false

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isDragging {
                            let impactLight = UIImpactFeedbackGenerator(
                                style: .light
                            )
                            impactLight.impactOccurred()
                        }

                        isDragging = true
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }
}

extension View {
    func hapticOnTouch() -> some View {
        modifier(HapticOnTouch())
    }
}
