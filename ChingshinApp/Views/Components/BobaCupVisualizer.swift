import SwiftUI

struct BobaCupVisualizer: View {
    let drink: Drink
    let size: DrinkSize
    let sugar: SugarLevel
    let ice: IceLevel
    let toppings: Set<Topping>
    
    @State private var isBouncing: Bool = false
    @State private var steamOffset: CGFloat = 0
    @State private var bubblePhase: Double = 0
    
    var body: some View {
        ZStack {
            // Background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [teaColor.opacity(0.35), Color.clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 110
                    )
                )
                .frame(width: 220, height: 220)
                .blur(radius: 10)
            
            // Main Cup Container
            VStack(spacing: 0) {
                // Cup Lid & Straw
                ZStack {
                    // Straw
                    Rectangle()
                        .fill(ChingShinTheme.primaryGreen)
                        .frame(width: 14, height: 50)
                        .cornerRadius(4)
                        .offset(x: 12, y: -20)
                    
                    // Sealed Lid Top
                    Capsule()
                        .fill(ChingShinTheme.accentRed)
                        .frame(width: 120, height: 16)
                        .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                        )
                }
                
                // Cup Body (Trapezoid container)
                ZStack(alignment: .bottom) {
                    // Empty Glass Shell
                    CupShape()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.white.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            CupShape()
                                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 5)
                    
                    // Liquid Content
                    CupShape()
                        .fill(
                            LinearGradient(
                                colors: [teaColor.opacity(0.85), teaColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .mask(
                            GeometryReader { geo in
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: geo.size.height * liquidFillRatio)
                                }
                            }
                        )
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: size)
                        .animation(.easeInOut(duration: 0.3), value: drink.id)
                    
                    // Toppings at bottom (Boba / Pearls)
                    if toppings.contains(where: { $0.id == "boba" }) || drink.name.contains("珍珠") || drink.name.contains("隱藏版") {
                        BobaPearlsLayer(isBouncing: isBouncing)
                            .padding(.bottom, 12)
                    }
                    
                    // Coconut / Jelly topping layer
                    if toppings.contains(where: { $0.id == "coconut" }) || toppings.contains(where: { $0.id == "grassJelly" }) {
                        JellyToppingLayer()
                            .padding(.bottom, 28)
                    }
                    
                    // Floating Ice Cubes (If cold drink)
                    if !ice.isHot && ice != .noIce {
                        FloatingIceCubesLayer(iceLevel: ice)
                            .padding(.top, 20)
                    }
                    
                    // Hot Steam Effect
                    if ice.isHot {
                        SteamParticlesLayer(offset: steamOffset)
                            .offset(y: -80)
                    }
                    
                    // Official Logo Stamp on Cup
                    VStack(spacing: 2) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Text("清心福全")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial.opacity(0.6))
                    .cornerRadius(10)
                    .offset(y: -40)
                }
                .frame(width: cupWidth, height: cupHeight)
            }
        }
        .scaleEffect(isBouncing ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isBouncing)
        .onChange(of: sugar) { _, _ in triggerBounce() }
        .onChange(of: ice) { _, _ in triggerBounce() }
        .onChange(of: toppings) { _, _ in triggerBounce() }
        .onChange(of: size) { _, _ in triggerBounce() }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                steamOffset = -10
            }
        }
    }
    
    private func triggerBounce() {
        isBouncing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isBouncing = false
        }
    }
    
    private var liquidFillRatio: CGFloat {
        size == .large ? 0.88 : 0.75
    }
    
    private var cupWidth: CGFloat {
        size == .large ? 120 : 108
    }
    
    private var cupHeight: CGFloat {
        size == .large ? 160 : 140
    }
    
    private var teaColor: Color {
        switch drink.teaTypeColor {
        case "green": return ChingShinTheme.greenTeaColor
        case "black": return ChingShinTheme.blackTeaColor
        case "oolong": return ChingShinTheme.oolongTeaColor
        case "milkTea": return ChingShinTheme.milkTeaColor
        case "fruit": return ChingShinTheme.fruitTeaColor
        case "slush": return ChingShinTheme.slushColor
        case "winterMelon": return ChingShinTheme.winterMelonColor
        default: return ChingShinTheme.milkTeaColor
        }
    }
}

// MARK: - Custom Cup Shape (Tapered Cylinder)
struct CupShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topWidth = rect.width
        let bottomWidth = rect.width * 0.76
        let height = rect.height
        let inset = (topWidth - bottomWidth) / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: topWidth, y: 0))
        path.addLine(to: CGPoint(x: topWidth - inset, y: height - 12))
        path.addQuadCurve(
            to: CGPoint(x: inset, y: height - 12),
            control: CGPoint(x: rect.width / 2, y: height + 2)
        )
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

// MARK: - Boba Pearls Layer
struct BobaPearlsLayer: View {
    let isBouncing: Bool
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<7, id: \.self) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.2), Color.black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 13, height: 13)
                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                    .offset(y: isBouncing ? CGFloat.random(in: -8...(-2)) : 0)
            }
        }
    }
}

// MARK: - Jelly Topping Layer
struct JellyToppingLayer: View {
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 14, height: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - Floating Ice Cubes Layer
struct FloatingIceCubesLayer: View {
    let iceLevel: IceLevel
    
    var count: Int {
        switch iceLevel {
        case .regularIce: return 5
        case .lessIce: return 3
        case .microIce: return 1
        default: return 0
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 14, height: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .rotationEffect(.degrees(Double.random(in: -20...20)))
            }
        }
    }
}

// MARK: - Steam Particles Layer
struct SteamParticlesLayer: View {
    let offset: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 6, height: 24)
                    .blur(radius: 3)
                    .offset(y: offset + CGFloat(i * -4))
            }
        }
    }
}
