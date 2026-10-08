import SwiftUI

struct MemberCardView: View {
    @Binding var userProfile: UserProfile
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var points: Int = 320
    @State private var memberLevel: String = "清心尊榮 VIP 會員"
    @State private var showBarcodeModal: Bool = false
    @State private var showCarrierEdit: Bool = false
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
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "064E3B"),
                                    Color(hex: "022C22"),
                                    Color(hex: "111827")
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "F59E0B"), Color(hex: "FCD34D"), Color(hex: "059669")]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color(hex: "064E3B").opacity(0.35), radius: 8, x: 0, y: 4)
                            
                            // Background subtle watermark
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(Color(hex: "F59E0B").opacity(0.07))
                                    .offset(x: 15, y: -5)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            
                            // Content strictly vertically balanced & centered
                            VStack(alignment: .leading, spacing: 0) {
                                // Top row: Member Badge & Show Barcode
                                HStack(alignment: .center) {
                                    HStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "F59E0B").opacity(0.2))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(Color(hex: "FCD34D"))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(memberLevel)
                                                .font(.system(size: 14, weight: .black))
                                                .foregroundColor(Color(hex: "FCD34D"))
                                            Text("CHING SHIN PRESTIGE CLUB")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(Color(hex: "10B981"))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        showBarcodeModal = true
                                    }) {
                                        HStack(spacing: 5) {
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
                                
                                Spacer(minLength: 12)
                                
                                // Middle row: Member Name & Points
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("持卡人 (Member)")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.65))
                                        Text(userProfile.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("紅利積點")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.65))
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
                                
                                Spacer(minLength: 12)
                                
                                // Bottom row: Progress to Next Tier
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("距離下一階級 (鑽石尊爵) 差 30 點")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.white.opacity(0.85))
                                        Spacer()
                                        Text("320 / 350")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(Color(hex: "FCD34D"))
                                    }
                                    
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule()
                                                .fill(Color.white.opacity(0.18))
                                                .frame(height: 5)
                                            Capsule()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "F59E0B"), Color(hex: "FCD34D")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: max(0, min(geo.size.width, geo.size.width * (320.0 / 350.0))), height: 5)
                                        }
                                    }
                                    .frame(height: 5)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 16)
                        }
                        .frame(height: 172)
                        .padding(.horizontal, 20)
                        
                        // Carrier Barcode Card (電子發票手機載具條碼 - 動態真實條碼)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                HStack(spacing: 6) {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.system(size: 15))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Text("電子發票手機載具條碼")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                }
                                
                                Spacer()
                                
                                // Quick Edit Button
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    showCarrierEdit = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "square.and.pencil")
                                            .font(.system(size: 11))
                                        Text("設定載具")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.primaryGreen.opacity(0.12))
                                    .clipShape(Capsule())
                                }
                                
                                // Enlarge Button
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    showBarcodeModal = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.system(size: 10))
                                        Text("放大")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.inputBg(isDarkMode))
                                    .clipShape(Capsule())
                                }
                            }
                            
                            // Real Code 128 Barcode Display Container
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                showCarrierEdit = true
                            }) {
                                VStack(spacing: 8) {
                                    if let barcodeImg = BarcodeGenerator.generateCode128(from: userProfile.carrierBarcode) {
                                        Image(uiImage: barcodeImg)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 52)
                                    } else {
                                        VStack(spacing: 4) {
                                            Image(systemName: "exclamationmark.triangle")
                                                .foregroundColor(.orange)
                                            Text("點擊此處設定有效手機載具 (如 /ABC1234)")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    
                                    HStack(spacing: 6) {
                                        Text(userProfile.carrierBarcode.isEmpty ? "（未設定載具）" : userProfile.carrierBarcode)
                                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                                            .foregroundColor(Color(hex: "1F2937"))
                                        
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppTheme.primaryGreen)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.primaryGreen)
                                Text("Code 128 真實條碼 ‧ 支援實體門市與超商掃瞄槍即時讀取")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                Spacer()
                            }
                        }
                        .padding(14)
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
                MemberBarcodeModalView(
                    userProfile: $userProfile,
                    points: points,
                    onOpenEdit: {
                        showBarcodeModal = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showCarrierEdit = true
                        }
                    }
                )
            }
            .sheet(isPresented: $showCarrierEdit) {
                CarrierBarcodeEditSheet(carrierBarcode: $userProfile.carrierBarcode)
            }
            .sheet(isPresented: $showProfileEdit) {
                MemberProfileEditView(profile: $userProfile)
            }
        }
    }
}

// Carrier Barcode Dedicated Edit Sheet (Live dynamic preview)
struct CarrierBarcodeEditSheet: View {
    @Binding var carrierBarcode: String
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var inputBarcode: String = ""
    @State private var hasCopied: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Live Barcode Preview Box
                        VStack(spacing: 12) {
                            Text("即時對應條碼預覽 (Live Barcode)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            
                            VStack(spacing: 8) {
                                if let barcodeImg = BarcodeGenerator.generateCode128(from: inputBarcode) {
                                    Image(uiImage: barcodeImg)
                                        .interpolation(.none)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .padding(.horizontal, 10)
                                } else {
                                    VStack(spacing: 6) {
                                        Image(systemName: "barcode.viewfinder")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray.opacity(0.6))
                                        Text("請在下方輸入載具號碼")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(height: 70)
                                }
                                
                                Text(inputBarcode.isEmpty ? "（未輸入）" : inputBarcode)
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(hex: "1F2937"))
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppTheme.primaryGreen.opacity(0.3), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.06), radius: 6, x: 0, y: 3)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Input Field Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("手機條碼載具號碼")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            
                            HStack {
                                Text("/")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .padding(.leading, 6)
                                
                                TextField("例如：ABC1234", text: Binding(
                                    get: {
                                        inputBarcode.hasPrefix("/") ? String(inputBarcode.dropFirst()) : inputBarcode
                                    },
                                    set: { newVal in
                                        let cleaned = newVal.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
                                        if cleaned.hasPrefix("/") {
                                            inputBarcode = cleaned
                                        } else if !cleaned.isEmpty {
                                            inputBarcode = "/" + cleaned
                                        } else {
                                            inputBarcode = ""
                                        }
                                    }
                                ))
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.characters)
                                
                                if !inputBarcode.isEmpty {
                                    Button(action: {
                                        inputBarcode = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                }
                            }
                            .padding(12)
                            .background(AppTheme.inputBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            // Quick Action Buttons
                            HStack(spacing: 8) {
                                Button("帶入範例 /ABC1234") {
                                    SoundManager.shared.playTapSound()
                                    inputBarcode = "/ABC1234"
                                }
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(AppTheme.secondaryCardBg(isDarkMode))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                .clipShape(Capsule())
                                
                                Button("清空") {
                                    SoundManager.shared.playTapSound()
                                    inputBarcode = ""
                                }
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(AppTheme.secondaryCardBg(isDarkMode))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                .clipShape(Capsule())
                                
                                Spacer()
                            }
                        }
                        .padding(16)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 20)
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .font(.system(size: 12))
                                Text("手機載具條碼規範說明")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            Text("1. 共通性載具由財政部核發，標準格式為首字斜線「/」加上 7 碼英數字或符號。\n2. 本系統使用標準 Code 128 編碼即時產生條碼，出示即可被店員條碼機掃描。\n3. 設定儲存後將同步保留於本機裝置。")
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                .lineSpacing(3)
                        }
                        .padding(14)
                        .background(AppTheme.secondaryCardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 20)
                        
                        // Save Button
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            let trimmed = inputBarcode.trimmingCharacters(in: .whitespacesAndNewlines)
                            let finalCode = trimmed.isEmpty ? "/ABC1234" : trimmed
                            carrierBarcode = finalCode
                            UserDefaults.standard.set(finalCode, forKey: "userCarrierBarcode")
                            SoundManager.shared.playAddToCartSound()
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("確認儲存載具條碼")
                                    .font(.system(size: 15, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: AppTheme.primaryGreen.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("設定發票載具條碼")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                }
            }
            .onAppear {
                inputBarcode = carrierBarcode.isEmpty ? "/ABC1234" : carrierBarcode
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
            // Left Discount Badge
            VStack(spacing: 3) {
                Text(coupon.discountBadgeText)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.white)
                Text(coupon.isPercent ? "超值回饋" : "折價現抵")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(hex: "FCD34D"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(Color.black.opacity(0.2))
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

// Member Barcode Modal View (Enlarged for Cashier Scanning)
struct MemberBarcodeModalView: View {
    @Binding var userProfile: UserProfile
    let points: Int
    var onOpenEdit: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 6) {
                        Text("清心福全 門市結帳掃描條碼")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                        Text("請出示予店員機台掃描積點與電子發票載具")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text(userProfile.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "1F2937"))
                            Spacer()
                            Text("紅利積點: \(points) 點")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "008B47"))
                        }
                        
                        // Scanner High-Contrast Pure White Card
                        VStack(spacing: 12) {
                            if let barcodeImg = BarcodeGenerator.generateCode128(from: userProfile.carrierBarcode) {
                                Image(uiImage: barcodeImg)
                                    .interpolation(.none)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .padding(.horizontal, 10)
                            } else {
                                Text("請設定有效載具號碼")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            Text(userProfile.carrierBarcode)
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "1F2937"))
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        // Status & Edit Button
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("電子發票手機載具 (Code 128)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "008B47"))
                                Text("螢幕亮度建議調高以加速條碼感應")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            
                            Spacer()
                            
                            if let onOpenEdit = onOpenEdit {
                                Button(action: onOpenEdit) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "pencil")
                                        Text("修改載具")
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.primaryGreen.opacity(0.12))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    
                    Button("關閉視窗") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    
                    Spacer()
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
                        UserDefaults.standard.set(profile.carrierBarcode, forKey: "userCarrierBarcode")
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
