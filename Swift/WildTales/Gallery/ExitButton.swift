import SwiftUI

struct ExitButton: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    // Circle size to keep consistent across elements
    let circleSize: CGFloat = 40

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .foregroundColor(.green1)
                    .frame(width: circleSize, height: circleSize)

                // White cross using rotated rectangles
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: circleSize * 0.6, height: circleSize * 0.1)
                    .cornerRadius(circleSize * 0.05)
                    .rotationEffect(.degrees(45))

                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: circleSize * 0.6, height: circleSize * 0.1)
                    .cornerRadius(circleSize * 0.05)
                    .rotationEffect(.degrees(-45))
            }

            Text("Exit")
                .foregroundColor(.primary)
                .font(.system(size: circleSize * 0.5, weight: .medium))
                .frame(height: circleSize)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    ExitButton()
}
