//
//  ImagePicker.swift
//  WildTales
//
//  Created by Yujie on 2025/4/30.
//  Reference https://www.youtube.com/watch?v=g-lJ2ODJD8E

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var showPicker: Bool
    @Binding var imageData: Data
    
    // Create delegate and set the source as album
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        
        return controller
    
    }
    
    // future use to update
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // It is called when user selects a photo, convert UIImage to png
        func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageData = (info[.originalImage] as? UIImage)?.pngData () {
                parent.imageData = imageData
                parent.showPicker.toggle()
            }
        }
        
        // cancenl picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showPicker.toggle() }
    }
    
}


