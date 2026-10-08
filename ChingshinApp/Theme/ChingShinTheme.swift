import SwiftUI

struct ChingShinTheme {
    // Brand Colors
    static let primaryGreen = Color(red: 0.0, green: 0.53, blue: 0.35) // #00875A Official ChingShin Green
    static let darkGreen = Color(red: 0.02, green: 0.40, blue: 0.26)
    static let lightGreen = Color(red: 0.88, green: 0.96, blue: 0.92)
    static let accentRed = Color(red: 0.90, green: 0.22, blue: 0.27) // Red emblem accent
    static let goldYellow = Color(red: 1.0, green: 0.72, blue: 0.01)
    
    // Background & Card colors
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let pageBackground = Color(UIColor.systemGroupedBackground)
    
    // Tea Colors for Visualizer
    static let greenTeaColor = Color(red: 0.65, green: 0.82, blue: 0.45)
    static let blackTeaColor = Color(red: 0.78, green: 0.38, blue: 0.18)
    static let oolongTeaColor = Color(red: 0.82, green: 0.58, blue: 0.28)
    static let milkTeaColor = Color(red: 0.88, green: 0.73, blue: 0.58)
    static let fruitTeaColor = Color(red: 0.98, green: 0.65, blue: 0.25)
    static let slushColor = Color(red: 0.92, green: 0.95, blue: 0.98)
    static let winterMelonColor = Color(red: 0.55, green: 0.35, blue: 0.20)
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

extension View {
    func glassCardStyle() -> some View {
        self.modifier(GlassCardModifier())
    }
}
