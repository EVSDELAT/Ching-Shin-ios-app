import SwiftUI

struct MemberCardView: View {
    @State private var points: Int = 1280
    @State private var isFlipped: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // VIP Digital Card (金卡會員卡)
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "008B47"), Color(hex: "004D25")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "008B47").opacity(0.4), radius: 12, x: 0, y: 6)
                        
                        VStack(alignment: .leading, spacing: 16) {
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
                            
                            VStack(alignment: .leading, spacing: 4) {
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
                                Text("8888 6688 9988 1688")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                                Image(systemName: "qrcode")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    
                    // Simulated Barcode for Store Scanning
                    VStack(spacing: 8) {
                        Text("門市出示條碼 輕鬆積點")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 3) {
                            ForEach(0..<32, id: \.self) { idx in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: idx % 3 == 0 ? 4 : 2, height: 50)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.04), radius: 6)
                    .padding(.horizontal)
                    
                    // Member Exclusive Perks / Vouchers
                    VStack(alignment: .leading, spacing: 14) {
                        Text("專屬優惠券 (3張可用)")
                            .font(.headline)
                            .bold()
                        
                        VStack(spacing: 10) {
                            VoucherCard(
                                title: "外帶自取 買五送一",
                                expireDate: "2026/12/31 到期",
                                tag: "門市專用",
                                color: Color(hex: "008B47")
                            )
                            VoucherCard(
                                title: "壽星專屬 全品項 85 折",
                                expireDate: "本月有效",
                                tag: "生日禮",
                                color: Color.red
                            )
                            VoucherCard(
                                title: "紅柚系列 折 10 元",
                                expireDate: "新品體驗",
                                tag: "限定折價",
                                color: Color.orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // App Version Footer Information
                    VStack(spacing: 6) {
                        Text("\(AppInfo.appName) iOS 官方點餐 App")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.secondary)
                        
                        Text("版本號: \(AppInfo.version) (Build 2026.10)")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 90)
                }
                .padding(.top)
            }
            .navigationTitle("會員專區 & 優惠卷")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "F8F9FA"))
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
