import SwiftUI

struct MemberCardView: View {
    @Binding var userProfile: UserProfile
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var points: Int = 320
    @State private var memberLevel: String = "清心尊榮 VIP 會員"
    @State private var showBarcodeModal: Bool = false
    @State private var showProfileEdit: Bool = false
    
    let coupons: [AppCoupon] = AppCoupon.sampleCoupons
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("會員專區")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Text("尊榮專屬禮遇與積點卡包")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                showProfileEdit = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 11))
                                    Text("編輯資料")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(AppTheme.primaryGreen)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(AppTheme.primaryGreen.opacity(0.12))
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        
                        // Luxury Metallic VIP Member Pass Card
                        ZStack(alignment: .bottomLeading) {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "064E3B"),
                                    Color(hex: "022C22"),
                                    Color(hex: "111827")
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "F59E0B"), Color(hex: "FCD34D"), Color(hex: "059669")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color(hex: "064E3B").opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 110))
                                        .foregroundColor(Color(hex: "F59E0B").opacity(0.08))
                                        .offset(x: 25, y: -15)
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    HStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "F59E0B").opacity(0.2))
                                                .frame(width: 30, height: 30)
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(Color(hex: "FCD34D"))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(memberLevel)
                                                .font(.system(size: 13, weight: .black))
                                                .foregroundColor(Color(hex: "FCD34D"))
                                            Text("VIP GOLD MEMBER")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        showBarcodeModal = true
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "qrcode")
                                                .font(.system(size: 12))
                                            Text("出示條碼")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.white.opacity(0.18))
                                        .clipShape(Capsule())
                                    }
                                }
                                
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("持卡人 (Member)")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.6))
                                        Text(userProfile.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("紅利積點")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.6))
                                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                            Text("\(points)")
                                                .font(.system(size: 24, weight: .black))
                                                .foregroundColor(Color(hex: "FCD34D"))
                                            Text("點")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("距離下一階級 (鑽石尊爵) 差 30 點")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                        Spacer()
                                        Text("320 / 350")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(Color(hex: "FCD34D"))
                                    }
                                    
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule()
                                                .fill(Color.white.opacity(0.15))
                                                .frame(height: 5)
                                            Capsule()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "F59E0B"), Color(hex: "FCD34D")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geo.size.width * (320.0 / 350.0), height: 5)
                                        }
                                    }
                                    .frame(height: 5)
                                }
                            }
                            .padding(16)
                        }
                        .frame(height: 185)
                        .padding(.horizontal, 20)
                        
                        // Carrier Barcode Card (電子發票手機載具條碼)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.primaryGreen)
                                Text("電子發票手機載具條碼")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Text("結帳掃描")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(AppTheme.primaryGreen.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                            
                            HStack {
                                Spacer()
                                VStack(spacing: 4) {
                                    HStack(spacing: 2.5) {
                                        ForEach(0..<26, id: \.self) { idx in
                                            Rectangle()
                                                .fill(idx % 3 == 0 ? Color.black : (idx % 2 == 0 ? Color.black.opacity(0.8) : Color.black.opacity(0.4)))
                                                .frame(width: idx % 5 == 0 ? 4 : (idx % 3 == 0 ? 2.5 : 1.5), height: 38)
                                        }
                                    }
                                    Text(userProfile.carrierBarcode)
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(Color(hex: "374151"))
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                Spacer()
                            }
                        }
                        .padding(12)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        
                        // Coupon Section (Deleted PrivilegePill per user requirement #1)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.primaryGreen)
                                Text("會員專屬獨享優惠券 (\(coupons.count)張)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 10) {
                                ForEach(coupons) { coupon in
                                    CouponCardView(coupon: coupon, isDark: isDarkMode)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 160)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showBarcodeModal) {
                MemberBarcodeModalView(userProfile: userProfile, points: points)
            }
            .sheet(isPresented: $showProfileEdit) {
                MemberProfileEditView(profile: $userProfile)
            }
        }
    }
}

// Coupon Card View
struct CouponCardView: View {
    let coupon: AppCoupon
    let isDark: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Value Badge
            VStack(spacing: 2) {
                Text(coupon.discountBadgeText)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(coupon.badge)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(hex: "FEF08A"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
            }
            .frame(width: 95)
            .frame(maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "005C2B")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Right Content Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(coupon.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDark))
                        .lineLimit(1)
                    Spacer()
                    Text("可使用")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.primaryGreen)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.primaryGreen.opacity(0.12))
                        .clipShape(Capsule())
                }
                
                Text("滿 $\(coupon.minSpend) 即可折抵優惠")
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary(isDark))
                    .lineLimit(1)
                
                HStack {
                    Text("效期至 2026/12/31")
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.textSecondary(isDark))
                    Spacer()
                    Button(action: { SoundManager.shared.playTapSound() }) {
                        Text("立即使用")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppTheme.primaryGreen)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(10)
        }
        .frame(height: 80)
        .background(AppTheme.cardBg(isDark))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(isDark ? 0.3 : 0.04), radius: 4, x: 0, y: 2)
    }
}

// AppCoupon Extension for Clean Left Badge Text
extension AppCoupon {
    var discountBadgeText: String {
        if isPercent {
            return "9 折"
        } else {
            return "折 $\(discountValue)"
        }
    }
}

// Member Barcode Modal View
struct MemberBarcodeModalView: View {
    let userProfile: UserProfile
    let points: Int
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 6) {
                        Text("清心福全 會員門市積點條碼")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                        Text("結帳前請出示予店員掃描")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text(userProfile.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "1F2937"))
                            Spacer()
                            Text("積點: \(points) 點")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "008B47"))
                        }
                        
                        VStack(spacing: 8) {
                            HStack(spacing: 3) {
                                ForEach(0..<30, id: \.self) { idx in
                                    Rectangle()
                                        .fill(idx % 3 == 0 ? Color.black : (idx % 2 == 0 ? Color.black.opacity(0.7) : Color.black.opacity(0.3)))
                                        .frame(width: idx % 5 == 0 ? 5 : (idx % 3 == 0 ? 3 : 2), height: 60)
                                }
                            }
                            Text(userProfile.phone)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "4B5563"))
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        VStack(spacing: 6) {
                            Text("手機載具條碼: \(userProfile.carrierBarcode)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "008B47"))
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    
                    Button("關閉視窗") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                }
            }
        }
    }
}

// Profile Edit View
struct MemberProfileEditView: View {
    @Binding var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                Form {
                    Section(header: Text("基本資料")) {
                        TextField("會員姓名", text: $profile.name)
                        TextField("手機號碼", text: $profile.phone)
                    }
                    
                    Section(header: Text("發票載具與預設地址")) {
                        TextField("手機條碼載具", text: $profile.carrierBarcode)
                        TextField("預設外送地址", text: $profile.defaultAddress)
                    }
                }
            }
            .navigationTitle("編輯會員個人資料")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        SoundManager.shared.playTapSound()
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
