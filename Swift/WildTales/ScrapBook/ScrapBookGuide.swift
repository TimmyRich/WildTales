//
//  ScrapBookGuide.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//  Updated by Yujie Wei on 18/4/2025.
//  Scrapbook main landing page with update visual elements. It provide users with
//  Inspired by https://www.youtube.com/watch?v=OaIn7HBlCSk

import SwiftUI
import UIKit
import AVFoundation
import Photos

// CameraView for taking photo

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var onImagePicked: (UIImage) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// PhotoLibraryView for picking photo from album

struct PhotoLibraryView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var onImagePicked: (UIImage) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoLibraryView

        init(_ parent: PhotoLibraryView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// Main ScrapBookGuide View

struct ScrapBookGuide: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var popupManager: PopupManager

    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var capturedImage: Image? = nil
    @State private var navigateToDrag = false

    @State private var showPermissionDeniedAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("scrapbookBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400)
                }
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("QuokkaCamera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 170, height: 200, alignment: .bottom)
                    }
                }

                VStack {
                    Spacer()

                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 100, height: 260)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Green1"), lineWidth: 1)
                        )
                        .shadow(radius: 5)

                    Spacer()
                }

                VStack(spacing: 10) {
                    Text("Scrapbook")
                        .font(Font.custom("Inter", size: 26))
                        .foregroundColor(.green1)

                    Text("Keep all your memories safe!")
                        .font(Font.custom("Inter", size: 14))
                        .foregroundColor(.green1)
                        .padding(.bottom, 20)

                    HStack(spacing: 30) {
                        VStack {
                            Button {
                                checkPhotoLibraryPermissionAndShow()
                            } label: {
                                Image("albumButton")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .hapticOnTouch()
                            }

                            Text("Add from Album")
                                .font(Font.custom("Inter", size: 8))
                        }

                        VStack {
                            Button {
                                checkCameraPermissionAndShow()
                            } label: {
                                Image("cameraButton")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                            .hapticOnTouch()

                            Text("Take Photo")
                                .font(Font.custom("Inter", size: 8))
                        }
                    }
                    .padding(.bottom, 15)

                    NavigationLink(destination: ScrapBookInstruction().navigationBarBackButtonHidden(true)) {
                        Text("Instructions")
                            .frame(width: UIScreen.main.bounds.width - 260, height: 25)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.black), lineWidth: 0.5)
                            )
                            .shadow(radius: 10)
                            .font(Font.custom("Inter", size: 12))
                    }
                    .hapticOnTouch()

                    Button("Show Image Gallery") {
                        withAnimation(.spring()) {
                            popupManager.present()
                        }
                        AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 220, height: 25)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.black), lineWidth: 0.5)
                    )
                    .shadow(radius: 10)
                    .font(Font.custom("Inter", size: 12))

                    // Hidden NavigationLink to ScrapBookDrag
                    NavigationLink(
                        destination: capturedImage != nil
                            ? AnyView(ScrapBookDrag(image: capturedImage!).navigationBarBackButtonHidden(true))
                            : AnyView(EmptyView()),
                        isActive: $navigateToDrag
                    ) {
                        EmptyView()
                    }

                }

                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .font(.system(size: 40))
                        .foregroundColor(Color("HunterGreen"))
                        .shadow(radius: 5)
                        .padding([.top, .leading], 40)

                        Spacer()
                    }
                    Spacer()
                }
                
                if showPermissionDeniedAlert {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        Text("Access Denied")
                            .font(.headline)
                        Text("Please enable access in Settings to continue.")
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("OK") {
                            showPermissionDeniedAlert = false
                        }
                        .padding()
                        .background(Color.green1)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
            .overlay(alignment: .bottom) {
                if popupManager.action.isPresented {
                    ScrapBookPopup {
                        withAnimation(.spring()) {
                            popupManager.dismiss()
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showCamera) {
                CameraView { uiImage in
                    capturedImage = Image(uiImage: uiImage)
                    navigateToDrag = true
                }
            }
            .sheet(isPresented: $showPhotoLibrary) {
                PhotoLibraryView { uiImage in
                    capturedImage = Image(uiImage: uiImage)
                    navigateToDrag = true
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Camera permission check and show camera if allowed

    func checkCameraPermissionAndShow() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        showCamera = true
                    } else {
                        showPermissionDeniedAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert = true
        @unknown default:
            showPermissionDeniedAlert = true
        }
    }

    // Photo library permission check and show photo library if allowed

    func checkPhotoLibraryPermissionAndShow() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            showPhotoLibrary = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        showPhotoLibrary = true
                    } else {
                        showPermissionDeniedAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert = true
        @unknown default:
            showPermissionDeniedAlert = true
        }
    }
}

// Preview for ScrapBookGuide

struct ScrapBookGuide_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookGuide().environmentObject(PopupManager())
    }
}
