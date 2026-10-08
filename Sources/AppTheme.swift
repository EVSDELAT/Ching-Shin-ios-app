import SwiftUI

struct AppTheme {
    static func bg(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "121820") : Color(hex: "F8F9FA")
    }
    
    static func cardBg(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "1E2630") : Color.white
    }
    
    static func textPrimary(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "F9FAFB") : Color(hex: "1F2937")
    }
    
    static func textSecondary(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "9CA3AF") : Color(hex: "6B7280")
    }
    
    static func border(_ isDark: Bool) -> Color {
        isDark ? Color(hex: "2D3748") : Color(hex: "E5E7EB")
    }
    
    static let primaryGreen = Color(hex: "008B47")
}
