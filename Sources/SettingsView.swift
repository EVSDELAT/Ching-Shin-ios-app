import SwiftUI
import WebKit

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isSoundEnabled") private var isSoundEnabled = true
    @AppStorage("pushEnabled") private var pushEnabled = true
    @AppStorage("promoEnabled") private var promoEnabled = true
    @AppStorage("autoLocation") private var autoLocation = true
    
    @State private var showCacheAlert = false
    @State private var cacheSize = "18.6 MB"
    @State private var showProfileEdit = false
    @State private var showWebsiteSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F8F9FA").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Banner
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("系統設定")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "1F2937"))
                                Text("個人資料、通知偏好與音效控制")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "008B47").opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "008B47"))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Section 1: Account Settings (Unified Green Icons - Requirement #5)
                        SettingsGroup(title: "帳號與個人檔案", icon: "person.circle.fill") {
                            SettingsNavigationRow(icon: "person.text.rectangle.fill", title: "編輯會員個人資料") {
                                SoundManager.shared.playTapSound()
                                showProfileEdit = true
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsNavigationRow(icon: "barcode", title: "手機發票載具條碼設定") {
                                SoundManager.shared.playTapSound()
                                showProfileEdit = true
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsNavigationRow(icon: "mappin.and.ellipse", title: "常用外送地址與門市") {
                                SoundManager.shared.playTapSound()
                                showProfileEdit = true
                            }
                        }
                        
                        // Section 2: Sound, Notifications & Haptics (Unified Green Icons - Requirement #5 & #8)
                        SettingsGroup(title: "音效與通知設定", icon: "speaker.wave.2.fill") {
                            SettingsToggleRow(icon: "speaker.wave.2.fill", title: "點餐與按鈕音效 (確認音效)", isOn: $isSoundEnabled) {
                                SoundManager.shared.playTapSound()
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "bell.fill", title: "訂單進度推播通知", isOn: $pushEnabled) {
                                SoundManager.shared.playTapSound()
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "sparkles", title: "最新優惠活動特報", isOn: $promoEnabled) {
                                SoundManager.shared.playTapSound()
                            }
                        }
                        
                        // Section 3: Interface & System (Unified Green Icons - Requirement #5)
                        SettingsGroup(title: "介面與系統", icon: "slider.horizontal.3") {
                            SettingsToggleRow(icon: "moon.fill", title: "深色模式 (Dark Mode)", isOn: $isDarkMode) {
                                SoundManager.shared.playTapSound()
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "location.fill", title: "開啟 GPS 自動定位門市", isOn: $autoLocation) {
                                SoundManager.shared.playTapSound()
                            }
                            Divider().padding(.leading, 44)
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                clearAppCache()
                                showCacheAlert = true
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(hex: "008B47").opacity(0.12))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "008B47"))
                                    }
                                    
                                    Text("清除快取暫存檔")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "1F2937"))
                                    
                                    Spacer()
                                    
                                    Text(cacheSize)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "9CA3AF"))
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 14)
                            }
                        }
                        
                        // Section 4: About & Support (Unified Green Icons - Requirement #5)
                        SettingsGroup(title: "關於與支援", icon: "info.circle.fill") {
                            SettingsNavigationRow(icon: "globe", title: "清心福全官方網站 (www.chingshin.tw)") {
                                SoundManager.shared.playTapSound()
                                openOfficialWebsite()
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsNavigationRow(icon: "phone.fill", title: "免付費客服專線 (0800-000-111)") {
                                SoundManager.shared.playTapSound()
                                dialHotline()
                            }
                        }
                        
                        // Section 5: Developer Credit Card (Zhao EVS)
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "005C2B")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                VStack(spacing: 10) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 48, height: 48)
                                            
                                            Image(systemName: "heart.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.red)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("清心福全 iOS App")
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(.white)
                                            Text("Ching Shin Fu Chuan Official App")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        Spacer()
                                        
                                        Text("v1.3.0")
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

// Group Component with Standardized Green Accent
struct SettingsGroup<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
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
                    .foregroundColor(Color(hex: "008B47"))
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "4B5563"))
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            .padding(.horizontal, 20)
        }
    }
}

// Unified Green Icon Navigation Row
struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "008B47").opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "008B47"))
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "D1D5DB"))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
    }
}

// Unified Green Icon Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    var onChange: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "008B47").opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "008B47"))
            }
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(hex: "1F2937"))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "008B47"))
                .onChange(of: isOn) { _ in
                    onChange?()
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}
