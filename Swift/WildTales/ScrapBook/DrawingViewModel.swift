//
//  DrawingViewModel.swift
//  WildTales
//
//  Created by Yujie on 2025/4/30.
//  Inspired by https://www.youtube.com/watch?v=g-lJ2ODJD8E
//  Edited by the suggestions provided by Chatgpt

import SwiftUI
import PencilKit
import Combine

class DrawingViewModel: ObservableObject {
    
    @Published var showImagePicker = false
    @Published var imageData: Data = Data()
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    //@Published var textBoxes : [TextBox] = []
    @Published var addNewBox = false
    @Published var backgroundImage: UIImage? = nil
    
    private var cancellable: AnyCancellable?
    
    

    init() {
        // Observe imageData changes and update view to respond
        cancellable = $imageData
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink {
                // Create a weak reference for view
                [weak self] image in
                guard let self = self else { return }
                // Update background with received image
                self.backgroundImage = image
                if image != nil {
                    // Clear drawing space and assign empty one
                    self.canvas.drawing = PKDrawing()
                }
            }
    }
    
    func cancelImageEditing() {
        imageData = Data()
        // Clear drawing
        canvas.drawing = PKDrawing()
    }
    
    // PencilKit tool
    func showToolPicker() {
             toolPicker.setVisible(true, forFirstResponder: canvas)
             toolPicker.addObserver(canvas)
             // Set up PKCanvasView
             DispatchQueue.main.async {
                  self.canvas.becomeFirstResponder()
             }
              
        }
    
}
