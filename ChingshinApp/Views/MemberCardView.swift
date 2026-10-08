import SwiftUI

struct MemberCardView: View {
    @State private var stampCount: Int = 7
    @State private var barcodeNumber = "8899 5200 1314"
    @State private var coupons = MockData.sampleCoupons
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // VIP Member Card Graphic
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                HStack(spacing: 8) {
                                    Image(systemName: "leaf.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(ChingShinTheme.goldYellow)
                                    Text("清心福全 VIP 尊榮黑卡")
                                        .font(.headline.bold())
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text("黃金會員")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(ChingShinTheme.goldYellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("會員卡號")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.7))
                                Text(barcodeNumber)
                                    .font(.title3.monospaced().bold())
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Image(systemName: "barcode")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("可用紅利點數")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("320 pts")
                                        .font(.title2.bold())
                                        .foregroundColor(ChingShinTheme.goldYellow)
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            LinearGradient(
                                colors: [Color(white: 0.15), Color(white: 0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        // Stamp Card (買10送1)
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("🧋 集點卡 (買10杯送1杯)")
                                    .font(.headline)
                                Spacer()
                                Text("\(stampCount)/10 杯")
                                    .font(.subheadline.bold())
                                    .foregroundColor(ChingShinTheme.primaryGreen)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(1...10, id: \.self) { index in
                                    ZStack {
                                        Circle()
                                            .fill(index <= stampCount ? ChingShinTheme.lightGreen : Color(UIColor.tertiarySystemGroupedBackground))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                Circle()
                                                    .stroke(index <= stampCount ? ChingShinTheme.primaryGreen : Color.clear, lineWidth: 2)
                                            )
                                        
                                        if index <= stampCount {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(ChingShinTheme.primaryGreen)
                                        } else if index == 10 {
                                            Text("🎁")
                                                .font(.title2)
                                        } else {
                                            Text("\(index)")
                                                .font(.caption.bold())
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
                            Button(action: {
                                withAnimation {
                                    if stampCount < 10 { stampCount += 1 } else { stampCount = 0 }
                                }
                            }) {
                                Text("⚡️ 點擊集一點 (Demo)")
                                    .font(.caption.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(ChingShinTheme.lightGreen)
                                    .foregroundColor(ChingShinTheme.darkGreen)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(20)
                        .background(ChingShinTheme.cardBackground)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Coupons List
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🎟️ 專屬優惠券")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(coupons) { coupon in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(coupon.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(coupon.discountText)
                                            .font(.subheadline.bold())
                                            .foregroundColor(ChingShinTheme.accentRed)
                                        Text("有效期限至 \(coupon.validUntil)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Button(coupon.isUsed ? "已使用" : "立即使用") {
                                        // Trigger use coupon
                                    }
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(coupon.isUsed ? Color.gray.opacity(0.3) : ChingShinTheme.primaryGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                }
                                .padding(16)
                                .background(ChingShinTheme.cardBackground)
                                .cornerRadius(16)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("會員與優惠專區")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
