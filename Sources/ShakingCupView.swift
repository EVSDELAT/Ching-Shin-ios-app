import SwiftUI

struct ShakingCupView: View {
    var isShaking: Bool = false
    var drinkColor: Color = Color(hex: "008B47")
    var hasBoba: Bool = true
    var iceCount: Int = 3
    var sizeMultiplier: CGFloat = 1.0
    
    @State private var shakeAngle: Double = 0
    @State private var pearlOffset: CGFloat = 0
    @State private var iceFloatOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                // Straw (吸管)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 8 * sizeMultiplier, height: 60 * sizeMultiplier)
                    .offset(x: 10 * sizeMultiplier, y: -25 * sizeMultiplier)
                    .rotationEffect(.degrees(10))
                
                // Cup Lid (封口膜 / 杯蓋)
                Capsule()
                    .fill(Color.white)
                    .overlay(
                        Capsule()
                            .stroke(Color(hex: "008B47"), lineWidth: 3 * sizeMultiplier)
                    )
                    .frame(width: 100 * sizeMultiplier, height: 18 * sizeMultiplier)
                    .zIndex(2)
                
                // Cup Body (杯身 - 經典清心錐形杯)
                ZStack {
                    // Transparent Cup Outline
                    TrapezoidShape()
                        .fill(
                            LinearGradient(
                                colors: [drinkColor.opacity(0.85), drinkColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            TrapezoidShape()
                                .stroke(Color.white.opacity(0.8), lineWidth: 3 * sizeMultiplier)
                        )
                    
                    // Foam/Ice layer on top
                    if iceCount > 0 {
                        HStack(spacing: 6 * sizeMultiplier) {
                            ForEach(0..<min(iceCount, 4), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.75))
                                    .frame(width: 12 * sizeMultiplier, height: 12 * sizeMultiplier)
                                    .rotationEffect(.degrees(Double.random(in: -15...15)))
                                    .offset(y: iceFloatOffset)
                            }
                        }
                        .offset(y: 15 * sizeMultiplier)
                    }
                    
                    // Brand Heart Logo on Cup
                    VStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20 * sizeMultiplier))
                            .foregroundColor(.red)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                        
                        Text("清心福全")
                            .font(.system(size: 11 * sizeMultiplier, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    }
                    .offset(y: -10 * sizeMultiplier)
                    
                    // Boba Pearls at bottom
                    if hasBoba {
                        VStack {
                            Spacer()
                            HStack(spacing: 4 * sizeMultiplier) {
                                ForEach(0..<6, id: \.self) { idx in
                                    Circle()
                                        .fill(Color.black.opacity(0.85))
                                        .frame(width: 12 * sizeMultiplier, height: 12 * sizeMultiplier)
                                        .offset(y: (idx % 2 == 0 ? pearlOffset : -pearlOffset))
                                }
                            }
                            .padding(.bottom, 15 * sizeMultiplier)
                        }
                    }
                }
                .frame(width: 90 * sizeMultiplier, height: 120 * sizeMultiplier)
                .offset(y: 8 * sizeMultiplier)
            }
        }
        .rotationEffect(.degrees(shakeAngle))
        .onAppear {
            if isShaking {
                startShakingAnimation()
            }
        }
        .onChange(of: isShaking) { newValue in
            if newValue {
                startShakingAnimation()
            } else {
                withAnimation(.spring()) {
                    shakeAngle = 0
                }
            }
        }
    }
    
    private func startShakingAnimation() {
        withAnimation(Animation.linear(duration: 0.12).repeatForever(autoreverses: true)) {
            shakeAngle = 14
            pearlOffset = 4
            iceFloatOffset = -3
        }
    }
}

// Custom Cup Trapezoid Shape
struct TrapezoidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topInset: CGFloat = 0
        let bottomInset: CGFloat = rect.width * 0.12
        
        path.move(to: CGPoint(x: rect.minX + topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - bottomInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + bottomInset, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ShakingCupView(isShaking: true, drinkColor: Color(hex: "008B47"))
}
