import SwiftUI

struct MemberCardView: View {
    @Binding var userProfile: UserProfile
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedIndex = 0
    @State private var showEditProfile = false
    
    let coupons = AppCoupon.sampleCoupons
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // User Welcome Header Card
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "005C2B")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 54, height: 54)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(userProfile.name)
                                        .font(.system(size: 19, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    
                                    Text("VIP 黑卡會員")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(hex: "1F2937"))
                                        .clipShape(Capsule())
                                }
                                
                                Text("電話：\(userProfile.phone)")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                showEditProfile = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12))
                                    Text("編輯")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(Color(hex: "008B47"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: "008B47").opacity(0.12))
                                .clipShape(Capsule())
                            }
                        }
                        .padding(16)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 3)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        
                        // Swipeable Barcode Carousel Card (會員條碼 / 發票載具)
                        VStack(spacing: 12) {
                            HStack {
                                Text(selectedIndex == 0 ? "清心會員紅利積點條碼" : "手機電子發票載具條碼")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                
                                Spacer()
                                
                                Text("左右滑動切換 ⇄")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            .padding(.horizontal, 16)
                            
                            TabView(selection: $selectedIndex) {
                                // Slide 1: Member Points Barcode
                                BarcodeSlideCard(
                                    title: "會員積點卡 (目前紅利 380 點)",
                                    barcodeValue: "/CS-VIP-889920",
                                    iconName: "qrcode",
                                    badgeText: "專屬會員卡",
                                    isDark: isDarkMode
                                )
                                .tag(0)
                                
                                // Slide 2: Mobile Carrier Invoice Barcode
                                BarcodeSlideCard(
                                    title: "電子發票載具 (已驗證)",
                                    barcodeValue: userProfile.carrierBarcode,
                                    iconName: "barcode",
                                    badgeText: "手機載具",
                                    isDark: isDarkMode
                                )
                                .tag(1)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(height: 185)
                        }
                        
                        // Section 3: 3 Official Coupons (Unified Green Palette - Requirement #4)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "008B47"))
                                Text("專屬優惠券 (\(coupons.count)張可使用)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            .padding(.horizontal, 16)
                            
                            VStack(spacing: 10) {
                                ForEach(coupons) { coupon in
                                    UnifiedCouponCard(coupon: coupon, isDark: isDarkMode)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Footer App Info
                        VStack(spacing: 4) {
                            Text("清心福全 iOS 官方點餐系統")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            Text("版本號: v1.4.0 (Build 2026.10)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode).opacity(0.8))
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditProfile) {
                MemberProfileEditView(profile: $userProfile)
            }
        }
    }
}

// Slide Card Component for Barcodes
struct BarcodeSlideCard: View {
    let title: String
    let barcodeValue: String
    let iconName: String
    let badgeText: String
    let isDark: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "005C2B")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(badgeText)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "008B47"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                
                // Simulated Barcode Box
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(height: 75)
                    
                    VStack(spacing: 4) {
                        HStack(spacing: 2) {
                            ForEach(0..<28, id: \.self) { idx in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: (idx % 3 == 0) ? 3 : (idx % 2 == 0 ? 1.5 : 2), height: 42)
                            }
                        }
                        
                        Text(barcodeValue)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(16)
        }
        .padding(.horizontal, 16)
    }
}

// Unified Coupon Card (Requirement #4: Unified Green & White Palette)
struct UnifiedCouponCard: View {
    let coupon: AppCoupon
    let isDark: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Badge Box
            VStack(spacing: 4) {
                Text(coupon.badge)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "008B47"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(hex: "FEF08A"))
                    .clipShape(Capsule())
                
                if coupon.isPercent {
                    Text("9折")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                } else {
                    HStack(alignment: .firstTextBaseline, spacing: 1) {
                        Text("$")
                            .font(.system(size: 13, weight: .bold))
                        Text("\(coupon.discountValue)")
                            .font(.system(size: 24, weight: .black))
                    }
                    .foregroundColor(.white)
                }
            }
            .frame(width: 85)
            .padding(.vertical, 16)
            .background(Color(hex: "008B47"))
            
            // Dotted Separator
            VStack(spacing: 4) {
                ForEach(0..<6) { _ in
                    Circle()
                        .fill(Color(hex: "008B47").opacity(0.3))
                        .frame(width: 3, height: 3)
                }
            }
            
            // Right Content Box
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(coupon.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDark))
                    Text(coupon.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary(isDark))
                    Text("有效期限：本月月底前有效")
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.textSecondary(isDark).opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    SoundManager.shared.playTapSound()
                }) {
                    Text("立即使用")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "008B47"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(hex: "008B47").opacity(0.12))
                        .clipShape(Capsule())
                }
            }
            .padding(14)
            .background(AppTheme.cardBg(isDark))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.border(isDark), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(isDark ? 0.2 : 0.04), radius: 6, x: 0, y: 3)
    }
}

// Member Profile Edit Sheet
struct MemberProfileEditView: View {
    @Binding var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempName: String = ""
    @State private var tempPhone: String = ""
    @State private var tempCarrier: String = ""
    @State private var tempAddress: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本聯絡資料")) {
                    HStack {
                        Text("姓名暱稱")
                        Spacer()
                        TextField("請輸入姓名", text: $tempName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("行動電話")
                        Spacer()
                        TextField("請輸入電話", text: $tempPhone)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("電子發票載具設定")) {
                    HStack {
                        Text("手機條碼載具")
                        Spacer()
                        TextField("如：/ABC1234", text: $tempCarrier)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("常用外送地址")) {
                    TextField("請輸入常用地址", text: $tempAddress)
                }
            }
            .navigationTitle("編輯個人資料")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                tempName = profile.name
                tempPhone = profile.phone
                tempCarrier = profile.carrierBarcode
                tempAddress = profile.defaultAddress
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        SoundManager.shared.playTapSound()
                        profile.name = tempName
                        profile.phone = tempPhone
                        profile.carrierBarcode = tempCarrier
                        profile.defaultAddress = tempAddress
                        dismiss()
                    }
                    .bold()
                    .foregroundColor(Color(hex: "008B47"))
                }
            }
        }
    }
}
