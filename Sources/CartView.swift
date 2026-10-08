import SwiftUI

struct CartView: View {
    @Binding var cartItems: [CartItem]
    @State var orderMode: OrderMode
    @State var deliveryInfo: DeliveryInfo
    var onCheckout: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedCoupon: AppCoupon? = AppCoupon.sampleCoupons[1] // Default: 本月獨享禮券 ($20)
    @State private var showCouponSheet: Bool = false
    
    var subtotal: Int {
        cartItems.reduce(0, { $0 + $1.totalPrice })
    }
    
    var couponDiscount: Int {
        guard let coupon = selectedCoupon else { return 0 }
        return coupon.calculateDiscount(subtotal: subtotal)
    }
    
    var deliveryFee: Int {
        orderMode == .delivery ? deliveryInfo.calculateDeliveryFee(subtotal: subtotal) : 0
    }
    
    var finalTotal: Int {
        max(0, subtotal - couponDiscount + deliveryFee)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Section 1: Order Mode Switcher (Takeout vs Delivery - Requirement #5)
                        VStack(spacing: 10) {
                            HStack {
                                Text("選擇取餐/配送方式")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                Spacer()
                            }
                            
                            HStack(spacing: 0) {
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    withAnimation(.spring(response: 0.3)) {
                                        orderMode = .takeout
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 12))
                                        Text("外帶自取")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .foregroundColor(orderMode == .takeout ? .white : AppTheme.textPrimary(isDarkMode))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(orderMode == .takeout ? Color(hex: "008B47") : Color.clear)
                                    .clipShape(Capsule())
                                }
                                
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    withAnimation(.spring(response: 0.3)) {
                                        orderMode = .delivery
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 12))
                                        Text("外送上門")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .foregroundColor(orderMode == .delivery ? .white : AppTheme.textPrimary(isDarkMode))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(orderMode == .delivery ? Color(hex: "008B47") : Color.clear)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(4)
                            .background(AppTheme.bg(isDarkMode))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppTheme.border(isDarkMode), lineWidth: 1))
                            
                            // Address Card
                            HStack(spacing: 10) {
                                Image(systemName: orderMode == .takeout ? "mappin.circle.fill" : "location.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: "008B47"))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(orderMode == .takeout ? "自取門市: 清心福全 台南總店(西門二店)" : "外送地址: \(deliveryInfo.address)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    Text(orderMode == .takeout ? "地址: 台南市中西區西門路二段222號" : "電話: \(deliveryInfo.phone) (備註: \(deliveryInfo.notes))")
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        .lineLimit(1)
                                }
                                Spacer()
                            }
                            .padding(10)
                            .background(AppTheme.bg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        
                        // Section 2: Cart Drink Items List
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("已點飲料明細 (\(cartItems.count)項)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(Array(cartItems.enumerated()), id: \.offset) { index, item in
                                    CartItemRowView(
                                        item: item,
                                        onDecrease: {
                                            SoundManager.shared.playTapSound()
                                            if cartItems[index].quantity > 1 {
                                                cartItems[index].quantity -= 1
                                            } else {
                                                cartItems.remove(at: index)
                                            }
                                        },
                                        onIncrease: {
                                            SoundManager.shared.playTapSound()
                                            cartItems[index].quantity += 1
                                        }
                                    )
                                }
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Section 3: Coupon Discount Picker (Requirement #5)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(Color(hex: "008B47"))
                                Text("優惠券折扣折抵")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                showCouponSheet = true
                            }) {
                                HStack {
                                    if let coupon = selectedCoupon {
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack(spacing: 6) {
                                                Text(coupon.title)
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(Color(hex: "008B47"))
                                                Text("(\(coupon.subtitle))")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                            }
                                            Text(subtotal >= coupon.minSpend ? "已成功折抵 -NT$ \(couponDiscount)" : "未符合滿額門檻 $ \(coupon.minSpend)")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(subtotal >= coupon.minSpend ? .red : .orange)
                                        }
                                    } else {
                                        Text("選擇優惠券 (目前未套用折扣)")
                                            .font(.system(size: 13))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                                .padding(12)
                                .background(AppTheme.bg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "008B47").opacity(0.4), lineWidth: 1)
                                )
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Section 4: Pricing Breakdown Summary Card
                        VStack(spacing: 10) {
                            HStack {
                                Text("金額試算明細")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("飲料小計")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                Spacer()
                                Text("NT$ \(subtotal)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            
                            if couponDiscount > 0 {
                                HStack {
                                    Text("優惠券折扣")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red)
                                    Spacer()
                                    Text("- NT$ \(couponDiscount)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.red)
                                }
                            }
                            
                            if orderMode == .delivery {
                                HStack {
                                    Text("外送服務費 (滿$150免運)")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    Spacer()
                                    Text(deliveryFee > 0 ? "+ NT$ \(deliveryFee)" : "免外送費 $0")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(deliveryFee > 0 ? Color.orange : Color(hex: "008B47"))
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("應付總金額")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Text("NT$ \(finalTotal)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "008B47"))
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
                
                // Sticky Action Bar (Confirm & Order)
                VStack {
                    Button(action: {
                        SoundManager.shared.playOrderSuccessSound()
                        onCheckout()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 15))
                            Text("確認點餐 ‧ 送出訂單")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("NT$ \(finalTotal)")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "008B47").opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .background(AppTheme.cardBg(isDarkMode).opacity(0.95))
            }
            .navigationTitle("購物車與點餐明細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                }
            }
            .sheet(isPresented: $showCouponSheet) {
                CouponSelectSheet(selectedCoupon: $selectedCoupon, subtotal: subtotal)
            }
        }
    }
}

// Subview for Cart Item Row
struct CartItemRowView: View {
    let item: CartItem
    let onDecrease: () -> Void
    let onIncrease: () -> Void
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        HStack(spacing: 12) {
            Drink3DThumbnailView(style: item.drink.cupStyle, size: 50)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.drink.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                
                Text(item.customizationSummary)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    .lineLimit(1)
                
                Text("NT$ \(item.unitPrice) / 杯")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "008B47"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("NT$ \(item.totalPrice)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                
                HStack(spacing: 8) {
                    Button(action: onDecrease) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                    
                    Text("\(item.quantity)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                    
                    Button(action: onIncrease) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "008B47"))
                    }
                }
            }
        }
        .padding(10)
        .background(AppTheme.bg(isDarkMode))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Coupon Selection Sheet Component
struct CouponSelectSheet: View {
    @Binding var selectedCoupon: AppCoupon?
    let subtotal: Int
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let coupons = AppCoupon.sampleCoupons
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                List {
                    Section(header: Text("選擇可套用的優惠券")) {
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            selectedCoupon = nil
                            dismiss()
                        }) {
                            HStack {
                                Text("不使用優惠券")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                if selectedCoupon == nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                            }
                        }
                        
                        ForEach(coupons) { coupon in
                            let isEligible = subtotal >= coupon.minSpend
                            let discountAmt = coupon.calculateDiscount(subtotal: subtotal)
                            
                            Button(action: {
                                if isEligible {
                                    SoundManager.shared.playTapSound()
                                    selectedCoupon = coupon
                                    dismiss()
                                }
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(isEligible ? Color(hex: "008B47") : Color.gray.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "ticket.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 6) {
                                            Text(coupon.title)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                            Text(coupon.badge)
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(hex: "008B47"))
                                                .clipShape(Capsule())
                                        }
                                        
                                        Text(coupon.subtitle)
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        
                                        Text(isEligible ? "可折抵 NT$ \(discountAmt)" : "未滿 $ \(coupon.minSpend) 門檻 (差 $ \(coupon.minSpend - subtotal))")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(isEligible ? Color(hex: "008B47") : .orange)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedCoupon?.id == coupon.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: "008B47"))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .disabled(!isEligible)
                        }
                    }
                }
            }
            .navigationTitle("選擇優惠券")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "008B47"))
                }
            }
        }
    }
}
