import SwiftUI

struct MemberCardView: View {
    @Binding var userProfile: UserProfile
    
    @State private var points: Int = 1280
    @State private var selectedCardTab: Int = 0
    @State private var isEditingProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Page Carousel: Card 1 (VIP Card) vs Card 2 (Invoice Carrier)
                    VStack(spacing: 8) {
                        TabView(selection: $selectedCardTab) {
                            // Card 1: VIP Member Points Card
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "008B47"), Color(hex: "004D25")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(hex: "008B47").opacity(0.35), radius: 10, x: 0, y: 5)
                                
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack {
                                        HStack(spacing: 8) {
                                            ZStack {
                                                Circle().fill(Color.red).frame(width: 30, height: 30)
                                                Image(systemName: "heart.fill").foregroundColor(.white).font(.caption)
                                            }
                                            Text("清心福全")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("VIP 金卡會員")
                                            .font(.caption)
                                            .bold()
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.yellow)
                                            .foregroundColor(.black)
                                            .clipShape(Capsule())
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("積點餘額")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                                            Text("\(points)")
                                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                            Text("點")
                                                .font(.headline)
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                    
                                    HStack {
                                        Text("會員卡號: 8888 6688 9988 1688")
                                            .font(.system(.caption2, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.85))
                                        Spacer()
                                        Text("↔ 左右滑動切換載具條碼")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding(18)
                            }
                            .padding(.horizontal)
                            .tag(0)
                            
                            // Card 2: Mobile Carrier Invoice Barcode
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "1E3A8A"), Color(hex: "0F172A")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color(hex: "1E3A8A").opacity(0.35), radius: 10, x: 0, y: 5)
                                
                                VStack(spacing: 12) {
                                    HStack {
                                        HStack(spacing: 6) {
                                            Image(systemName: "doc.text.fill")
                                                .foregroundColor(.cyan)
                                            Text("電子發票手機載具條碼")
                                                .font(.headline)
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        Text(userProfile.carrierBarcode)
                                            .font(.system(.subheadline, design: .monospaced))
                                            .bold()
                                            .foregroundColor(.cyan)
                                    }
                                    
                                    // Barcode Graphic
                                    VStack(spacing: 4) {
                                        HStack(spacing: 3) {
                                            ForEach(0..<28, id: \.self) { idx in
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: idx % 3 == 0 ? 5 : 2, height: 48)
                                            }
                                        }
                                        Text(userProfile.carrierBarcode)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .padding(.vertical, 6)
                                    
                                    Text("結帳出示此頁，店員直接掃描儲存發票")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(18)
                            }
                            .padding(.horizontal)
                            .tag(1)
                        }
                        .frame(height: 195)
                        .tabViewStyle(.page(indexDisplayMode: .always))
                    }
                    
                    // Profile Info & Settings Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("會員個人資料與設定")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Button(action: { isEditingProfile = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "pencil")
                                    Text("編輯資料")
                                }
                                .font(.caption)
                                .bold()
                                .foregroundColor(Color(hex: "008B47"))
                            }
                        }
                        
                        VStack(spacing: 10) {
                            ProfileInfoRow(icon: "person.fill", title: "姓名暱稱", value: userProfile.name)
                            ProfileInfoRow(icon: "phone.fill", title: "聯絡電話", value: userProfile.phone)
                            ProfileInfoRow(icon: "doc.text.fill", title: "發票載具", value: userProfile.carrierBarcode)
                            ProfileInfoRow(icon: "mappin.and.ellipse", title: "常用外送地址", value: userProfile.defaultAddress)
                            ProfileInfoRow(icon: "gift.fill", title: "生日 / 性別", value: "\(userProfile.birthday) (\(userProfile.gender))")
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Exclusive Coupons
                    VStack(alignment: .leading, spacing: 14) {
                        Text("會員專屬優惠券")
                            .font(.headline)
                            .bold()
                        
                        VStack(spacing: 10) {
                            VoucherCard(title: "外帶自取 買五送一", expireDate: "2026/12/31 到期", tag: "門市專用", color: Color(hex: "008B47"))
                            VoucherCard(title: "壽星專屬 全品項 85 折", expireDate: "本月有效", tag: "生日禮", color: Color.red)
                            VoucherCard(title: "RedBull 能量特調 折 10 元", expireDate: "新品體驗", tag: "限定折扣", color: Color.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    // App Version Footer
                    VStack(spacing: 4) {
                        Text("\(AppInfo.appName) iOS 官方點餐 App")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.secondary)
                        
                        Text("版本號: \(AppInfo.version) (Build 2026.10)")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 90)
                }
                .padding(.top, 4)
            }
            .navigationTitle("會員專區 & 載具條碼")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "F8F9FA"))
            .sheet(isPresented: $isEditingProfile) {
                MemberProfileEditView(profile: $userProfile)
            }
        }
    }
}

// MARK: - Subviews
struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color(hex: "008B47"))
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)
        }
        .padding(.vertical, 2)
    }
}

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
                        Text("聯絡電話")
                        Spacer()
                        TextField("請輸入電話", text: $tempPhone)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.phonePad)
                    }
                }
                
                Section(header: Text("發票與外送設定")) {
                    HStack {
                        Text("發票載具條碼")
                        Spacer()
                        TextField("例如 /ABC1234", text: $tempCarrier)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("預設外送地址")
                        Spacer()
                        TextField("請輸入地址", text: $tempAddress)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("設定個人會員資料")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
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
            .onAppear {
                tempName = profile.name
                tempPhone = profile.phone
                tempCarrier = profile.carrierBarcode
                tempAddress = profile.defaultAddress
            }
        }
    }
}

struct VoucherCard: View {
    let title: String
    let expireDate: String
    let tag: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(tag)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.15))
                        .foregroundColor(color)
                        .clipShape(Capsule())
                    
                    Text(title)
                        .font(.subheadline)
                        .bold()
                }
                Text(expireDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("立即使用") { }
                .font(.caption)
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(color)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.03), radius: 4)
    }
}
