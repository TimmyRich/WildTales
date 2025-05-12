import SwiftUI

// Get available badges, including unlocked badges
func getAvailableBadges() -> [String] {
    // badges available by default
    var defaultBadges: [String] = ["moon-badge", "possum-badge", "cloud-badge"]
    // locations belonging to a certain zone
    let BotanicalGardensLocations = LocationLoader.loadLocations().filter { $0.zone == "Botanical Gardens" }
    let SouthbankParklandsLocations = LocationLoader.loadLocations().filter { $0.zone == "Southbank Parklands" }
    let UQLocations = LocationLoader.loadLocations().filter { $0.zone == "University of Queensland" }

    if (BotanicalGardensLocations.allSatisfy { $0.visited == 1 }) {
        defaultBadges.append("bird-badge")
    }
    if (SouthbankParklandsLocations.allSatisfy { $0.visited == 1 }) {
        defaultBadges.append("ibis-badge")
    }
    if (UQLocations.allSatisfy { $0.visited == 1 }) {
        defaultBadges.append("quokka-badge")
    }
    return defaultBadges
}

struct BadgeDecoratorView: View {
    @Environment(\.presentationMode) var presentationMode

    let trailName: String
    let helpMessage: String = "Tap a badge to add it. Drag, pinch, or rotate to adjust. Drag offscreen to delete."

    @StateObject private var badgeLoader = BadgeLoader()
    
    let availableBadges: [String] = getAvailableBadges()

    var body: some View {
        VStack {
            
            // Page title
            Text("The \(trailName) trail")
                .font(.title)
                .padding(.top, -8)
                .foregroundColor(Color(red: 25/255, green: 71/255, blue: 41/255))

            // Help message, directs user to manipulate badges
            Text(helpMessage)
                .frame(width: 250)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            GeometryReader { geo in
                ZStack {
                    let imageWidth: CGFloat = 260
                    let imageHeight: CGFloat = 550
                    let imageOrigin = CGPoint(
                        x: (geo.size.width - imageWidth) / 2,
                        y: (geo.size.height - imageHeight) / 2
                    )
                    
                    // Safe area for placing badfges
                    let imageRect = CGRect(origin: imageOrigin, size: CGSize(width: imageWidth, height: imageHeight))

                    // Trail image
                    Image(trailName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth, height: imageHeight)
                        .border(Color.black, width: 4)
                        .position(x: imageRect.midX, y: imageRect.midY)

                    // Render each badge associated with this trail
                    ForEach($badgeLoader.data) { $badge in
                        if (badge.parentImage == trailName) {
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
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            
            // Badge selector
            HStack(alignment: .center, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(availableBadges, id: \.self) { badgeName in
                            Button(action: {
                                let newBadge = Badge(imageName: badgeName, x: 200, y: 300, parentImage: trailName)
                                badgeLoader.addBadge(newBadge)
                            }) {
                                Image(badgeName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    badgeLoader.removeAllBadges(parentImage: trailName)
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
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 70)
            .padding(.bottom)


        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    badgeLoader.saveBadges()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("page_back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .onDisappear {
            badgeLoader.saveBadges()
        }
    }

    
}

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
