import SwiftUI

struct BadgeDecoratorView: View {
    @Environment(\.presentationMode) var presentationMode

    let imageName: String
    let availableBadges = ["moon-badge", "ibis-badge", "possum-badge", "cloud-badge", "bird-badge", "quokka-badge"]

    @StateObject private var badgeLoader = BadgeLoader()

    var body: some View {
        VStack {
            Text("The \(imageName) trail")
                .font(.title)
                .padding(.top, -8)
                .foregroundColor(Color(red: 25/255, green: 71/255, blue: 41/255))

            Text(statusMessage)
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
                    let imageRect = CGRect(origin: imageOrigin, size: CGSize(width: imageWidth, height: imageHeight))

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth, height: imageHeight)
                        .border(Color.black, width: 4)
                        .position(x: imageRect.midX, y: imageRect.midY)

                    ForEach($badgeLoader.data) { $badge in
                        if (badge.parentImage == imageName) {
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

            HStack(alignment: .center, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(availableBadges, id: \.self) { badgeName in
                            Button(action: {
                                let newBadge = Badge(imageName: badgeName, x: 200, y: 300, parentImage: imageName)
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
                    badgeLoader.removeAllBadges(parentImage: imageName)
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
            .frame(height: 70)
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

    private var statusMessage: String {
        return "Tap a badge to add it. Drag, pinch, or rotate to adjust. Drag offscreen to delete."
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
