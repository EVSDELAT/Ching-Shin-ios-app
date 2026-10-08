import SwiftUI

struct SettingsView: View {
    @State private var pushEnabled = true
    @State private var promoEnabled = true
    @State private var hapticEnabled = true
    @State private var autoLocation = true
    @State private var isDarkMode = false
    @State private var showCacheAlert = false
    @State private var cacheSize = "18.6 MB"
    @State private var showProfileEdit = false
    
    var body: some View {
        NavigationView {
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
                                Text("偏好設定、通知與應用程式資訊")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "008641").opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "008641"))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Section 1: Account Settings
                        SettingsGroup(title: "帳號與個人檔案", icon: "person.circle.fill") {
                            SettingsNavigationRow(icon: "person.text.rectangle.fill", iconColor: .blue, title: "編輯會員個人資料") {
                                showProfileEdit = true
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsNavigationRow(icon: "barcode", iconColor: .orange, title: "手機發票載具條碼設定") {
                                showProfileEdit = true
                            }
                            Divider().padding(.leading, 44)
                            
                            SettingsNavigationRow(icon: "mappin.and.ellipse", iconColor: .red, title: "常用外送地址與門市") {
                            }
                        }
                        
                        // Section 2: Notifications & Preferences
                        SettingsGroup(title: "通知與偏好", icon: "bell.badge.fill") {
                            SettingsToggleRow(icon: "bell.fill", iconColor: .purple, title: "訂單進度推播通知", isOn: $pushEnabled)
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "sparkles", iconColor: .yellow, title: "最新優惠活動特報", isOn: $promoEnabled)
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "hand.tap.fill", iconColor: .green, title: "按鍵觸控震動回饋", isOn: $hapticEnabled)
                        }
                        
                        // Section 3: Interface & System
                        SettingsGroup(title: "介面與系統", icon: "slider.horizontal.3") {
                            SettingsToggleRow(icon: "moon.fill", iconColor: .indigo, title: "深色模式 (Dark Mode)", isOn: $isDarkMode)
                            Divider().padding(.leading, 44)
                            
                            SettingsToggleRow(icon: "location.fill", iconColor: .teal, title: "開啟 GPS 自動定位門市", isOn: $autoLocation)
                            Divider().padding(.leading, 44)
                            
                            Button(action: {
                                showCacheAlert = true
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.orange.opacity(0.15))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.orange)
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
                        
                        // Section 4: About & Support
                        SettingsGroup(title: "關於與支援", icon: "info.circle.fill") {
                            SettingsNavigationRow(icon: "globe", iconColor: Color(hex: "008641"), title: "清心福全官方網站") {}
                            Divider().padding(.leading, 44)
                            SettingsNavigationRow(icon: "phone.fill", iconColor: .blue, title: "免付費客服專線 (0800-000-111)") {}
                            Divider().padding(.leading, 44)
                            SettingsNavigationRow(icon: "doc.text.fill", iconColor: .gray, title: "服務條款與隱私權政策") {}
                        }
                        
                        // Section 5: Developer Info (Mandatory User Requirement #4)
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "008641"), Color(hex: "005C2B")]),
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
                                        
                                        Text("v1.1.0")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color(hex: "008641"))
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
                    message: Text("成功釋放 18.6 MB 的暫存空間。"),
                    dismissButton: .default(Text("確定")) {
                        cacheSize = "0.0 MB"
                    }
                )
            }
        }
    }
}

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
                    .foregroundColor(Color(hex: "008641"))
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

struct SettingsNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(iconColor)
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

struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(hex: "1F2937"))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "008641"))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
    }
}
