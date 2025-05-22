/*
 -- Acknowledgments --

 Heavily inspired by https://www.youtube.com/watch?v=O3QAI8Mxh8M . GenAI was used to develop the logic for determining when an
 image was placed out of bounds using a geometryReader with prompt: "Use a GeometryReader to define a safe area inside the
'Image(trailName)'. Make a function which checks if a badge has been placed outside of this safe area"
 */

import SwiftUI

// Get available badges, including unlocked badges
func getAvailableBadges() -> [String] {

    // Adds the badge associated with a zone if all locations in that zone have been added
    func addZoneBadge(zone: String, badge: String) {
        let filteredLocations = LocationLoader.loadLocations().filter {
            $0.zone == zone
        }

        if filteredLocations.isEmpty {
            return
        }

        if (filteredLocations.allSatisfy { $0.visited == 1 }) {
            defaultBadges.append(badge)
        }
    }

    // badges available by default
    var defaultBadges: [String] = ["moon-badge", "possum-badge", "cloud-badge", "cow-badge", "monkey-badge", "turtle-badge", "tongue-badge"]

    addZoneBadge(zone: "University of Queensland", badge: "quokka-badge")
    addZoneBadge(zone: "Southbank Parklands", badge: "ibis-badge")
    addZoneBadge(zone: "Botanical Gardens", badge: "bird-badge")
    addZoneBadge(zone: "Custom", badge: "smiley-badge")
    return defaultBadges
}

struct BadgeDecoratorView: View {
    @Environment(\.presentationMode) var presentationMode
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    let trailName: String
    let helpMessage: String =
        "Tap a badge to add it. Drag, pinch, or rotate to adjust. Drag offscreen to delete."

    @StateObject private var badgeLoader = BadgeLoader()
    let availableBadges: [String] = getAvailableBadges()

    @State private var currentIndex: Int = 0
    let scrollStep = 3

    // Track the safe image rect so BadgeView and DragTarget can use it
    @State private var imageRect: CGRect = .zero

    // For dragging badges from the bottom row
    @State private var draggedBadgeName: String? = nil
    @State private var dragLocation: CGPoint = .zero

    var body: some View {
        VStack {

            // Page title
            Text("The \(trailName) trail")
                .font(.title)
                .padding(.top, -8)
                .foregroundColor(Color(red: 25 / 255, green: 71 / 255, blue: 41 / 255))

            // Help message
            Text(helpMessage)
                .frame(width: 250)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            GeometryReader { geo in
                ZStack {
                    let imageWidth: CGFloat = screenWidth * 0.6
                    let imageHeight: CGFloat = screenHeight * 0.6
                    let imageOrigin = CGPoint(
                        x: (geo.size.width - imageWidth) / 2,
                        y: (geo.size.height - imageHeight) / 2
                    )

                    let rect = CGRect(
                        origin: imageOrigin,
                        size: CGSize(width: imageWidth, height: imageHeight)
                    )

                    // Save the imageRect state for access elsewhere
                    Color.clear
                        .onAppear {
                            imageRect = rect
                        }
                        .onChange(of: geo.size) { _ in
                            imageRect = rect
                        }

                    Image(trailName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth, height: imageHeight)
                        .position(x: rect.midX, y: rect.midY)

                    // Existing badges on the image
                    ForEach($badgeLoader.data) { $badge in
                        if badge.parentImage == trailName && availableBadges.contains(badge.imageName) {
                            BadgeView(
                                badge: $badge,
                                imageRect: imageRect,
                                removeBadge: {
                                    withAnimation {
                                        badgeLoader.removeBadge(badge)
                                    }
                                }
                            )
                        }
                    }

                    // Badge being dragged from bottom row (ghost)
                    if let draggedName = draggedBadgeName {
                        Image(draggedName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .position(dragLocation)
                            .opacity(0.8)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(height: screenHeight * 0.65)

            // Badge selector with scroll buttons
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    if currentIndex > 0 {
                        currentIndex = max(0, currentIndex - scrollStep)
                    }
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                }) {
                    Image("back_button")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(availableBadges.enumerated()), id: \.element) { index, badgeName in
                                BadgeDragSource(
                                    badgeName: badgeName,
                                    imageRect: imageRect,
                                    onDropOnImage: { location in
                                        let newBadge = Badge(
                                            imageName: badgeName,
                                            x: location.x,
                                            y: location.y,
                                            parentImage: trailName
                                        )
                                        badgeLoader.addBadge(newBadge)
                                        AudioManager.playSound(
                                            soundName: "boing.wav",
                                            soundVol: 0.5
                                        )
                                    },
                                    draggedBadgeName: $draggedBadgeName,
                                    dragLocation: $dragLocation
                                )
                                .id(index)
                            }
                        }
                        .padding(.horizontal)
                        .onChange(of: currentIndex) { index in
                            withAnimation {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    }
                }

                Button(action: {
                    badgeLoader.removeAllBadges(parentImage: trailName)
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .padding(.trailing)

                Button(action: {
                    if currentIndex < availableBadges.count - 1 {
                        currentIndex = min(availableBadges.count - 1, currentIndex + scrollStep)
                    }
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                }) {
                    Image("forward_button")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 70)
            .padding(.bottom)
        }
        .coordinateSpace(name: "badgeSpace")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    badgeLoader.saveBadges()
                    presentationMode.wrappedValue.dismiss()
                    AudioManager.playSound(
                        soundName: "boing.wav",
                        soundVol: 0.5
                    )
                }) {
                    Image("page_back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
        })
        .onDisappear {
            badgeLoader.saveBadges()
        }
    }
}

// MARK: - BadgeView

struct BadgeView: View {
    @Binding var badge: Badge
    let imageRect: CGRect
    let removeBadge: () -> Void

    @State private var initialScale: CGFloat = 1.0
    @State private var initialRotation: Angle = .zero

    private let badgeSize: CGFloat = 50

    var body: some View {
        Image(badge.imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(badge.scale)
            .rotationEffect(Angle(degrees: badge.degrees))
            .position(x: badge.x, y: badge.y)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                badge.x = value.location.x
                                badge.y = value.location.y
                            }
                            .onEnded { _ in
                                checkIfOutOfBounds()
                            },
                        MagnificationGesture()
                            .onChanged { value in
                                badge.scale = initialScale * value
                            }
                            .onEnded { _ in
                                initialScale = badge.scale
                                checkIfOutOfBounds()
                            }
                    ),
                    RotationGesture()
                        .onChanged { angle in
                            badge.degrees = (initialRotation + angle).degrees
                        }
                        .onEnded { _ in
                            initialRotation = Angle(degrees: badge.degrees)
                        }
                )
            )
            .onAppear {
                initialScale = badge.scale
                initialRotation = Angle(degrees: badge.degrees)
            }
    }

    private func checkIfOutOfBounds() {
        let actualBadgeWidth = badgeSize * badge.scale
        let actualBadgeHeight = badgeSize * badge.scale
        let insetX = actualBadgeWidth / 2
        let insetY = actualBadgeHeight / 2
        let safeImageRect = imageRect.insetBy(dx: insetX, dy: insetY)

        if !safeImageRect.contains(CGPoint(x: badge.x, y: badge.y)) {
            removeBadge()
        }
    }
}

// MARK: - BadgeDragSource

/// A badge in the bottom row that can be dragged onto the image
struct BadgeDragSource: View {
    let badgeName: String
    let imageRect: CGRect
    let onDropOnImage: (CGPoint) -> Void

    @Binding var draggedBadgeName: String?
    @Binding var dragLocation: CGPoint

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            Image(badgeName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            draggedBadgeName = badgeName

                            let badgeFrame = geo.frame(in: .named("badgeSpace"))
                            dragLocation = CGPoint(
                                x: badgeFrame.minX + value.location.x,
                                y: badgeFrame.minY + value.location.y
                            )
                        }
                        .onEnded { value in
                            draggedBadgeName = nil
                            dragOffset = .zero

                            let badgeFrame = geo.frame(in: .named("badgeSpace"))
                            let dropPoint = CGPoint(
                                x: badgeFrame.minX + value.location.x,
                                y: badgeFrame.minY + value.location.y
                            )

                            if imageRect.contains(dropPoint) {
                                onDropOnImage(dropPoint)
                            }
                        }
                )
        }
        .frame(width: 50, height: 50)

    }
}

