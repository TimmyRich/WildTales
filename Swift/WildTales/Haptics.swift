//
//  Haptics.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//
// This code was created by ChatGPT, prompt "Create a function I can call from my code that create a quick haptic buzz".
// The following code was output.
//
// Current issues with this function is that when called from the main code, it can stop other functions from being processed.

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
                            let impactLight = UIImpactFeedbackGenerator( //impact feedback for user to feel
                                style: .light
                            )
                            impactLight.impactOccurred() // light impact
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
