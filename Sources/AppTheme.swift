import SwiftUI

struct AppTheme {
    @AppStorage("themeMode") static var themeMode: String = "light" // "system", "light", "dark"
    
    static func isDark(_ systemScheme: ColorScheme) -> Bool {
        if themeMode == "dark" { return true }
        if themeMode == "light" { return false }
        return systemScheme == .dark
    }
    
    // OLED Pure Deep Black / Charcoal Background
    static func bg(_ isDark: Bool) -> Color {
        isDark ? Color.black : Color(hex: "F8F9FA")
    }
    
    static func cardBg(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "121212") : Color.white
    }
    
    static func secondaryCardBg(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "1E1E1E") : Color(hex: "F3F4F6")
    }
    
    static func inputBg(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "1E1E1E") : Color(hex: "EFEFF4")
    }
    
    static func textPrimary(_ isDark: Bool) -> Color {
        isDark ? Color.white : Color(hex: "1F2937")
    }
    
    static func textSecondary(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "9CA3AF") : Color(hex: "6B7280")
    }
    
    static func border(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "27272A") : Color(hex: "E5E7EB")
    }
    
    static let primaryGreen = Color(hex: "008B47")
    static let primaryGreenLight = Color(hex: "00A865")
    static let accentRed = Color(hex: "E53E3E")
    static let accentGold = Color(hex: "D97706")
}
