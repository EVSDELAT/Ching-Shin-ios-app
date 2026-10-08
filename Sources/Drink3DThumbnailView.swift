import SwiftUI

struct Drink3DThumbnailView: View {
    let style: CupVisualType
    var size: CGFloat = 90
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [cupGradientColors.first?.opacity(0.3) ?? .green.opacity(0.2), Color.clear],
                        center: .center,
                        startRadius: 5,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size * 1.1, height: size * 1.1)
            
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.red)
                    .frame(width: size * 0.08, height: size * 0.3)
                    .offset(x: size * 0.1, y: size * 0.08)
                    .rotationEffect(.degrees(12))
                    .zIndex(2)
                
                Capsule()
                    .fill(Color.white)
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                    .frame(width: size * 0.65, height: size * 0.12)
                    .zIndex(3)
                
                ZStack {
                    TrapezoidShape()
                        .fill(
                            LinearGradient(
                                colors: cupGradientColors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: cupGradientColors.last?.opacity(0.4) ?? .black.opacity(0.2), radius: 4, y: 3)
                    
                    TrapezoidShape()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.white.opacity(0.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .scaleEffect(x: 0.35, y: 0.9)
                        .offset(x: -size * 0.12)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.16))
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.2), radius: 1)
                        .offset(y: -size * 0.06)
                    
                    if style == .bobaMilkTea || style == .hiddenSpecial || style == .iceCreamType {
                        VStack {
                            Spacer()
                            HStack(spacing: size * 0.04) {
                                ForEach(0..<4, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.black.opacity(0.85))
                                        .frame(width: size * 0.1, height: size * 0.1)
                                }
                            }
                            .padding(.bottom, size * 0.08)
                        }
                    }
                }
                .frame(width: size * 0.58, height: size * 0.65)
                .offset(y: -size * 0.02)
            }
        }
        .frame(width: size, height: size)
    }
    
    var cupGradientColors: [Color] {
        switch style {
        case .bobaMilkTea:
            return [Color(hex: "D7CCC8"), Color(hex: "8D6E63")]
        case .greenTea:
            return [Color(hex: "A5D6A7"), Color(hex: "2E7D32")]
        case .fruitTea:
            return [Color(hex: "FFF59D"), Color(hex: "FBC02D")]
        case .hiddenSpecial:
            return [Color(hex: "81C784"), Color(hex: "1B5E20")]
        case .redTea:
            return [Color(hex: "EF9A9A"), Color(hex: "B71C1C")]
        case .iceCreamType:
            return [Color(hex: "E0F7FA"), Color(hex: "00ACC1")]
        case .hotSpecialType:
            return [Color(hex: "FFCC80"), Color(hex: "E65100")]
        }
    }
}
