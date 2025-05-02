//
//  CanvasView.swift
//  WildTales
//
//  Created by Yujie Wei on 2025/4/30.
//  Inspired by https://www.youtube.com/watch?v=g-lJ2ODJD8E

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }

}
