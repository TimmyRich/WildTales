//
//  ScrapBookDrag.swift
//  WildTales
//
//  Created by Yujie Wei on 10/5/2025.
//  Updated by Kurt McCullough on 22/5/2025
//  Heavily inspired by the following content
//  Inspired by https://www.youtube.com/watch?v=2ZK5wfbvvS4
//  Inspired by https://www.youtube.com/watch?v=lMteVjlOIbM
//  Inspired by https://www.youtube.com/watch?v=ZkOvD3okAJo
//  Drag page allows users to decorate the selected picture. They can drag stickers and place them on picture, edit the title and save the edited picture to album.
//
// Save Image button was taken from ChatGPT, prompt was "Make the 'Save Image' button take a screenshot of the photo with pins and save it to the users photo library.
// Function createDragGesture and function undoLastAction are derived from google gemini with the prompt "If I want to drag and drop the sticker image to the scene image. How can I edit code to do it?" The other parts of code like variables dragStartPosition,currentDragSticker, dragOffset, etc are also modified based on the change according to the code provided by genAI

import PhotosUI
import SwiftUI

// Represents a sticker that has been dropped on the photo, with position
struct DropSticker: Identifiable {
    let id = UUID()
    var imageName: String
    var position: CGPoint
}

// Represents a selectable sticker in the sticker selection bar
struct SelectSticker: Identifiable {
    let id = UUID()
    let imageName: String
}

struct ScrapBookDrag: View {
    let image: Image

    @Environment(\.presentationMode) var goBack

    // Array holding all stickers placed on the photo
    @State private var finishedSticker: [DropSticker] = []

    // The sticker currently being dragged from the sticker selection
    @State private var currentDragSticker: SelectSticker? = nil

    // Offset of the current drag gesture
    @State private var dragOffset: CGSize = .zero

    // Starting location of the drag gesture in global coordinates
    @State private var dragStartPosition: CGPoint? = nil

    // Global frame of the photo area, used for drop position calculation
    @State private var photoAreaLocation: CGRect = .zero

    // Used for scrolling stickers in the sticker bar
    @State private var stickerIndex = 2

    // Title text shown above the photo
    @State private var titleText: String = "Title Text"

    // Controls showing the title editing alert
    @State private var isEditingTitle: Bool = false

    // Controls showing the save confirmation alert
    @State private var showSaveConfirmation = false

    // For moving existing stickers: stores which sticker is currently being dragged
    @State private var draggingStickerID: UUID? = nil

    // Starting position of the currently dragging sticker
    @State private var draggingStickerInitialPosition: CGPoint? = nil

    let areaCoordinateSpace = "photoDropArea"
    let zoomedStickerSize: CGFloat = 70  // Size of sticker while dragging
    let placedStickerSize: CGFloat = 60  // Size of sticker once placed

    // Stickers available for selection in the sticker bar
    let StickersInBar: [SelectSticker] = [
        SelectSticker(imageName: "badgeQuin"),
        SelectSticker(imageName: "badgeBird"),
        SelectSticker(imageName: "badgeMoon"),
        SelectSticker(imageName: "badgeRat"),
        SelectSticker(imageName: "badgeCrane"),
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Header.padding(.bottom, UIScreen.main.bounds.height * 0.08)
                PrimaryPhoto.padding(.horizontal, 20)
                Spacer()
                StickerSelectionView.padding(.vertical, 10)
                BottomButton
            }

            // Show the sticker currently being dragged with some opacity
            if let sticker = currentDragSticker,
                let startPos = dragStartPosition
            {
                Image(sticker.imageName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.7)
                    .frame(width: zoomedStickerSize)
                    .position(
                        x: startPos.x + dragOffset.width,
                        y: startPos.y + dragOffset.height
                    )
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.white)
        .navigationBarHidden(true)
        // Alert for editing the title text
        .alert("Edit Title", isPresented: $isEditingTitle) {
            TextField("Title", text: $titleText)
            Button("Done", role: .cancel) {}
        } message: {
            Text("Enter a new title for your scrapbook")
        }
        // Alert shown when the image is saved successfully
        .alert("Saved!", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(
                "Your edited image has been saved to your phone's photo library!"
            )
        }
    }

    // Header view with title, undo, and back buttons
    var Header: some View {
        HStack {
            ZStack {
                HStack {
                    VStack {
                        Text(titleText)
                            .bold()
                            .font(Font.custom("Inter", size: 30))
                            .foregroundColor(.green1)
                        Text("Drag sticker to decorate photo")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                // Undo button to remove last placed sticker
                Button {
                    undoLastAction()
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.title)
                }
                .disabled(finishedSticker.isEmpty)
                .padding(.leading, UIScreen.main.bounds.width - 70)
                .padding(.bottom)

                // Back button to dismiss the view
                Button {
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                    goBack.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .font(.system(size: 40))
                .foregroundColor(Color("HunterGreen"))
                .shadow(radius: 5)
                .padding(.trailing, UIScreen.main.bounds.width - 70)
            }
        }
        .foregroundColor(.green1)
        .frame(height: 50)
        .padding(.top)
    }

    // The main photo area where stickers can be dropped
    var PrimaryPhoto: some View {
        GeometryReader { geometry in
            photoArea
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    // Capture the global frame of the photo area for drag/drop position calculations
                    photoAreaLocation = geometry.frame(in: .global)
                }
                .onChange(of: geometry.frame(in: .global)) { newValue in
                    photoAreaLocation = newValue
                }
                .coordinateSpace(name: areaCoordinateSpace)
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.8,
            height: UIScreen.main.bounds.height * 0.4
        )
    }

    // The photo with all the placed stickers overlaid
    var photoArea: some View {
        let screenWidth = UIScreen.main.bounds.width
        let photoAreaWidth = min(screenWidth - 60, 330)
        let photoAreaHeight = photoAreaWidth * (4.0 / 3.0)

        return ZStack(alignment: .topTrailing) {
            // Base photo
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: photoAreaWidth, height: photoAreaHeight)
                .clipped()

            // For each sticker placed, show it and enable dragging it to reposition
            ForEach(finishedSticker) { sticker in
                Image(sticker.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: placedStickerSize)
                    .position(sticker.position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Start dragging this sticker if none is being dragged
                                if draggingStickerID == nil {
                                    draggingStickerID = sticker.id
                                    draggingStickerInitialPosition =
                                        sticker.position
                                }

                                // Update sticker position as drag changes
                                if let index = finishedSticker.firstIndex(
                                    where: { $0.id == sticker.id }),
                                    let initial = draggingStickerInitialPosition
                                {
                                    finishedSticker[index].position = CGPoint(
                                        x: initial.x + value.translation.width,
                                        y: initial.y + value.translation.height
                                    )
                                }
                            }
                            .onEnded { _ in
                                // Reset dragging state after drag ends
                                draggingStickerID = nil
                                draggingStickerInitialPosition = nil
                            }
                    )
            }
        }
        .frame(width: photoAreaWidth, height: photoAreaHeight)
    }

    // Snapshot view combining the title and photo with stickers, used for saving an image
    var combinedSnapshotView: some View {
        VStack(spacing: 10) {
            Text(titleText)
                .bold()
                .font(Font.custom("Inter", size: 30))
                .foregroundColor(.green1)
            photoArea
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(Color.white)
    }

    // Horizontal sticker selection bar with back/forward buttons for scrolling
    var StickerSelectionView: some View {
        ScrollViewReader { proxy in
            HStack(spacing: 15) {
                // Back button scrolls left in the sticker list
                Button {
                    withAnimation {
                        stickerIndex = max(0, stickerIndex - 2)
                        let targetID = StickersInBar[stickerIndex].id
                        proxy.scrollTo(targetID, anchor: .center)
                    }
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                } label: {
                    Image("back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.leading, -7)
                }.disabled(stickerIndex == 0)

                // Scrollable row of sticker images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(StickersInBar) { sticker in
                            Image(sticker.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(5)
                                .id(sticker.id)
                                .gesture(createDragGesture(for: sticker))
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .frame(height: 70)

                // Forward button scrolls right in the sticker list
                Button {
                    withAnimation {
                        stickerIndex = min(
                            StickersInBar.count - 1,
                            stickerIndex + 2
                        )
                        let targetID = StickersInBar[stickerIndex].id
                        proxy.scrollTo(targetID, anchor: .center)
                    }
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                } label: {
                    Image("forward_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding(.trailing, -7)
                }.disabled(stickerIndex >= StickersInBar.count - 1)
            }
            .padding(.horizontal)
            .foregroundColor(.green1)
        }
    }

    // Bottom button bar with Save Image and Change Title buttons
    var BottomButton: some View {
        HStack(spacing: 30) {
            Spacer()
            // Save the combined view to photo library
            Button {
                if let screenshot = snapshotCombinedView() {
                    saveImageToPhotos(screenshot)
                    showSaveConfirmation = true
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                } else {
                    print("Failed to capture screenshot")
                }
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill").font(.system(size: 24))
                    Text("Save Image").font(.caption).multilineTextAlignment(
                        .center
                    ).lineLimit(2)
                }.foregroundColor(.green1).frame(minWidth: 100)
            }
            Spacer()
            // Show alert to edit the title text
            Button {
                isEditingTitle = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "pencil.line").font(.system(size: 24))
                    Text("Change Title").font(.caption).multilineTextAlignment(
                        .center
                    ).lineLimit(2)
                }.foregroundColor(.green1).frame(minWidth: 100)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .padding(.bottom, safeAreaBottom())
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(
                Color(.black),
                lineWidth: 1
            )
        )
    }

    // Creates the drag gesture for stickers in the sticker bar
    // Edit the following code based on the usage of AI Gemini
    func createDragGesture(for sticker: SelectSticker) -> some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                // Initialize drag start position and currently dragged sticker
                if dragStartPosition == nil {
                    dragStartPosition = value.startLocation
                }
                if currentDragSticker == nil { currentDragSticker = sticker }

                // Update drag offset as finger moves
                dragOffset = CGSize(
                    width: value.location.x - value.startLocation.x,
                    height: value.location.y - value.startLocation.y
                )
            }
            .onEnded { value in
                // If sticker dropped inside the photo area, add it to finished stickers
                if let currentSticker = currentDragSticker,
                    photoAreaLocation.contains(value.location)
                {
                    let localX = value.location.x - photoAreaLocation.origin.x
                    let localY = value.location.y - photoAreaLocation.origin.y
                    let localPosition = CGPoint(x: localX, y: localY)
                    let newSticker = DropSticker(
                        imageName: currentSticker.imageName,
                        position: localPosition
                    )
                    finishedSticker.append(newSticker)
                }
                // Reset drag state
                currentDragSticker = nil
                dragOffset = .zero
                dragStartPosition = nil
            }
    }

    // Removes the last placed sticker
    func undoLastAction() {
        if !finishedSticker.isEmpty {
            finishedSticker.removeLast()
        }
    }
    // End AI assisted coding

    // Provides a fixed safe area bottom padding value
    func safeAreaBottom() -> CGFloat { return 30 }

    // Takes a snapshot UIImage of the combined title and photo area with stickers
    func snapshotCombinedView() -> UIImage? {
        let width = UIScreen.main.bounds.width * 0.8
        let photoAreaWidth = min(width - 60, 330)
        let photoAreaHeight = photoAreaWidth * (4.0 / 3.0)
        let totalHeight: CGFloat = 40 + photoAreaHeight + 10

        let controller = UIHostingController(rootView: combinedSnapshotView)
        controller.view.bounds = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: totalHeight
        )
        controller.view.backgroundColor = UIColor.clear

        let renderer = UIGraphicsImageRenderer(
            size: controller.view.bounds.size
        )
        return renderer.image { _ in
            controller.view.drawHierarchy(
                in: controller.view.bounds,
                afterScreenUpdates: true
            )
        }
    }

    // Saves the given UIImage to the photo library
    func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct ScrapBookDrag_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookDrag(image: Image("displayImage2"))
    }
}
