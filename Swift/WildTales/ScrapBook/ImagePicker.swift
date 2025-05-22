//
//  ImagePicker.swift
//  WildTales
//
//  Created by Yujie on 2025/4/30.
//  It allows users to select from photo library in SwiftUi view
//  Heavily inspired by the following content
//  Reference https://www.youtube.com/watch?v=g-lJ2ODJD8E

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?
    // dimiss the image picker view
    @Environment(\.presentationMode) private var presentationMode

    // Create delegate and set the source as album
    func makeUIViewController(context: Context) -> UIImagePickerController {

        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator

        return controller

    }

    // future use to update
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {

    }

    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate,
        UINavigationControllerDelegate
    {
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }

        // It is called when user successfully selects a photo, convert UIImage to png
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController
                .InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()

        }

        // cancenl picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
