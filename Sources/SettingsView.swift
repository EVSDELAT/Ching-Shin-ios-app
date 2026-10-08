import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("themeMode") private var themeMode: String = "light"
    @AppStorage("isSoundEnabled") private var isSoundEnabled = true
    @AppStorage("isHapticEnabled") private var isHapticEnabled = true
    @AppStorage("isNotificationEnabled") private var isNotificationEnabled = true
    
    @State private var cacheSize: String = "12.4 MB"
    @State private var showCacheAlert: Bool = false
    @State private var showProfileEdit: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("系統設定")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Text("偏好設定與 App 系統維護")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Group 1: Appearance & Theme
                        SettingsGroup(title: "顯示與主題設定", icon: "paintbrush.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("App 外觀主題")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                
                                Picker("主題模式", selection: $themeMode) {
                                    Text("☀️ 淺色模式 (預設)").tag("light")
                                                                        Text("💻 系統預設").tag("system")
                                                                    }
                                .pickerStyle(.segmented)
                                .onChange(of: themeMode) { newMode in
                                    SoundManager.shared.playTapSound()
                                    if newMode == "dark" {
                                        isDarkMode = true
                                    } else if newMode == "light" {
                                        isDarkMode = false
                                    }
                                }
                            }
                            .padding(14)
                        }
                        
                        // Group 2: Sound & Feedback
                        SettingsGroup(title: "音效與觸覺回饋", icon: "speaker.wave.2.fill") {
                            VStack(spacing: 0) {
                                SettingsToggleRow(icon: "speaker.wave.2", title: "App 操作音效", isOn: $isSoundEnabled) {
                                    if isSoundEnabled {
                                        SoundManager.shared.playAddToCartSound()
                                    }
                                }
                                
                                Divider().padding(.leading, 50)
                                
                                SettingsToggleRow(icon: "hand.tap.fill", title: "觸覺震動回饋", isOn: $isHapticEnabled) {
                                    if isHapticEnabled {
                                        SoundManager.shared.playTapSound()
                                    }
                                }
                                
                                Divider().padding(.leading, 50)
                                
                                SettingsToggleRow(icon: "bell.fill", title: "訂單與優惠推播", isOn: $isNotificationEnabled)
                            }
                        }
                        
                        // Group 3: Data & Storage
                        SettingsGroup(title: "資料與快取管理", icon: "sdcard.fill") {
                            VStack(spacing: 0) {
                                SettingsNavigationRow(icon: "person.crop.circle", title: "修改會員個人資料") {
                                    showProfileEdit = true
                                }
                                
                                Divider().padding(.leading, 50)
                                
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    clearAppCache()
                                    showCacheAlert = true
                                }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.red.opacity(0.12))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "trash.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.red)
                                        }
                                        
                                        Text("清理暫存檔案容量")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                        
                                        Spacer()
                                        
                                        Text(cacheSize)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 14)
                                }
                            }
                        }
                        
                        // Group 4: Official Customer Service & Links
                        SettingsGroup(title: "顧客服務與資訊", icon: "phone.bubble.left.fill") {
                            VStack(spacing: 0) {
                                SettingsNavigationRow(icon: "globe", title: "清心福全官方網站") {
                                    openOfficialWebsite()
                                }
                                
                                Divider().padding(.leading, 50)
                                
                                SettingsNavigationRow(icon: "phone.fill", title: "客服專線: 0800-000-111") {
                                    dialHotline()
                                }
                            }
                        }
                        
                        // App Version Badge Card
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "005C2B")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: Color(hex: "008B47").opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 42, height: 42)
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.red)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("清心福全線上訂購系統")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.white)
                                        Text("Ching Shin Fu Chuan Official App")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    Spacer()
                                    
                                    Text("v1.5.0")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "008B47"))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.white)
                                        .clipShape(Capsule())
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.25))
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "hammer.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(hex: "FEF08A"))
                                            Text("開發者 (Developer):")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.white.opacity(0.9))
                                            Text("Zhao EVS")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color(hex: "FEF08A"))
                                        }
                                        
                                        Text("版權所有 © 2026 Ching Shin Fu Chuan. All Rights Reserved.")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.75))
                                    }
                                    Spacer()
                                }
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 120)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showProfileEdit) {
                MemberProfileEditView(profile: .constant(UserProfile(name: "Zhao EVS", phone: "0912-345-678", carrierBarcode: "/ABC1234", defaultAddress: "台南市中西區西門路二段100號", birthday: "1998/06/18", gender: "男")))
            }
            .alert(isPresented: $showCacheAlert) {
                Alert(
                    title: Text("快取已清理"),
                    message: Text("成功釋放暫存檔案空間。目前快取容量為 0.0 MB。"),
                    dismissButton: .default(Text("確定"))
                )
            }
        }
    }
    
    private func clearAppCache() {
        let tmpDir = NSTemporaryDirectory()
        try? FileManager.default.contentsOfDirectory(atPath: tmpDir).forEach { file in
            try? FileManager.default.removeItem(atPath: (tmpDir as NSString).appendingPathComponent(file))
        }
        cacheSize = "0.0 MB"
    }
    
    private func openOfficialWebsite() {
        if let url = URL(string: "https://www.chingshin.tw") {
            UIApplication.shared.open(url)
        }
    }
    
    private func dialHotline() {
        if let url = URL(string: "tel://0800000111") {
            UIApplication.shared.open(url)
        }
    }
}

// Group Component
struct SettingsGroup<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.primaryGreen)
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppTheme.cardBg(isDarkMode))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
        }
    }
}

// Navigation Row
struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.primaryGreen.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.primaryGreen)
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
    }
}

// Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    var onChange: (() -> Void)? = nil
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.primaryGreen.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.primaryGreen)
            }
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppTheme.textPrimary(isDarkMode))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppTheme.primaryGreen)
                .onChange(of: isOn) { _ in
                    onChange?()
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}
