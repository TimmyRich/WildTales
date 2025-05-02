import SwiftUI


struct BadgeDecoratorView: View {
    @Environment(\.presentationMode) var presentationMode

    let imageName: String
    let availableBadges = ["moon-badge", "ibis-badge", "possum-badge", "cloud-badge", "bird-badge", "quokka-badge"]

    @State private var badgesOnImage: [Badge] = []

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
                    // Image frame setup
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

                    ForEach($badgesOnImage) { $badge in
                        BadgeView(
                            badge: $badge,
                            imageRect: imageRect,
                            removeBadge: {
                                withAnimation {
                                    badgesOnImage.removeAll { $0.id == badge.id }
                                }
                            }
                        )
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            
            HStack(spacing: 20) {
                ForEach(availableBadges, id: \.self) { badgeName in
                    Button(action: {
                        // Add a new badge to the center
                        badgesOnImage.append(
                            Badge(imageName: badgeName, position: CGPoint(
                                x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY))
                        )
                    }) {
                        Image(badgeName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("page_back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
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
            .frame(width: badgeSize, height: badgeSize)
            .scaleEffect(badge.scale)
            .rotationEffect(badge.rotation)
            .position(badge.position)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                badge.position = value.location
                            }
                            .onEnded { _ in
                                let actualBadgeWidth = badgeSize * badge.scale
                                let actualBadgeHeight = badgeSize * badge.scale
                                let insetX = actualBadgeWidth / 2
                                let insetY = actualBadgeHeight / 2

                                let safeImageRect = imageRect.insetBy(dx: insetX, dy: insetY)

                                if !safeImageRect.contains(badge.position) {
                                    removeBadge()
                                }
                            },
                        MagnificationGesture()
                            .onChanged { value in
                                badge.scale = initialScale * value
                            }
                            .onEnded { _ in
                                initialScale = badge.scale
                                
                                let actualBadgeWidth = badgeSize * badge.scale
                                let actualBadgeHeight = badgeSize * badge.scale
                                let insetX = actualBadgeWidth / 2
                                let insetY = actualBadgeHeight / 2

                                let safeImageRect = imageRect.insetBy(dx: insetX, dy: insetY)

                                if !safeImageRect.contains(badge.position) {
                                    removeBadge()
                                }
                            }
                    ),
                    RotationGesture()
                        .onChanged { angle in
                            badge.rotation = initialRotation + angle
                        }
                        .onEnded { _ in
                            initialRotation = badge.rotation
                        }
                )
            )
            .onAppear {
                // Set initial values on appear
                initialScale = badge.scale
                initialRotation = badge.rotation
            }
    }
}
