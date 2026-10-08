import SwiftUI

struct CartView: View {
    @Binding var cartItems: [CartItem]
    @Binding var orderMode: OrderMode
    @Binding var selectedStore: Store
    @Binding var deliveryInfo: DeliveryInfo
    var onCheckout: () -> Void
    var onOpenStoreLocator: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedCoupon: AppCoupon? = AppCoupon.sampleCoupons[1] // Default: 本月獨享禮券 ($20)
    @State private var showCouponSheet: Bool = false
    @State private var showDeliverySetupSheet: Bool = false
    
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
                        // Section 1: Order Mode Switcher & Store/Address Selector (Requirement #2)
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
                                    .background(orderMode == .takeout ? AppTheme.primaryGreen : Color.clear)
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
                                    .background(orderMode == .delivery ? AppTheme.primaryGreen : Color.clear)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(4)
                            .background(AppTheme.bg(isDarkMode))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppTheme.border(isDarkMode), lineWidth: 1))
                            
                            // Store & Location Cards (Interactive & Syncing with Main Page)
                            if orderMode == .takeout {
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    onOpenStoreLocator()
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(AppTheme.primaryGreen)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack(spacing: 4) {
                                                Text("自取門市: \(selectedStore.shortName)")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                            }
                                            Text("地址: \(selectedStore.address)")
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
                            } else {
                                VStack(spacing: 8) {
                                    // Store Selector Pill for Delivery
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        onOpenStoreLocator()
                                    }) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "storefront.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(AppTheme.primaryGreen)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                HStack(spacing: 4) {
                                                    Text("外送門市: \(selectedStore.shortName)")
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 9, weight: .bold))
                                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                                }
                                                Text("地址: \(selectedStore.address)")
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
                                    
                                    // Delivery Address Selector Pill
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        showDeliverySetupSheet = true
                                    }) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "location.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(AppTheme.primaryGreen)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                HStack(spacing: 4) {
                                                    Text("配送地址: \(deliveryInfo.address)")
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                    Image(systemName: "chevron.right")
                                                        .font(.system(size: 9, weight: .bold))
                                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                                }
                                                Text("電話: \(deliveryInfo.phone) (備註: \(deliveryInfo.notes))")
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
                                }
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        
                        // Section 2: Cart Drink Items List
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("已點飲料明細 (\(cartItems.reduce(0, { $0 + $1.quantity }))項)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
                            if cartItems.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "cart")
                                        .font(.system(size: 36))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    Text("購物車目前是空的")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(cartItems) { item in
                                        CartItemRowView(item: item, isDark: isDarkMode) { action in
                                            handleItemAction(item: item, action: action)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Section 3: Member Coupon Picker Sheet Trigger
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.primaryGreen)
                                Text("優惠券折扣折抵")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                showCouponSheet = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        if let coupon = selectedCoupon {
                                            Text(coupon.title)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(AppTheme.primaryGreen)
                                            Text("已成功折抵 -\(couponDiscount) 元")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(AppTheme.accentRed)
                                        } else {
                                            Text("未選擇優惠券")
                                                .font(.system(size: 13))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                            Text("點擊選擇可用的專屬優惠券")
                                                .font(.system(size: 11))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppTheme.primaryGreen)
                                }
                                .padding(12)
                                .background(AppTheme.primaryGreen.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.primaryGreen.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        // Section 4: Price Breakdown Card
                        VStack(spacing: 10) {
                            HStack {
                                Text("金額試算明細")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                            }
                            
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
                                    Text("優惠券折抵")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.accentRed)
                                    Spacer()
                                    Text("- NT$ \(couponDiscount)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(AppTheme.accentRed)
                                }
                            }
                            
                            if orderMode == .delivery {
                                HStack {
                                    Text("外送服務費 (\(subtotal >= deliveryInfo.minDeliveryThreshold ? "滿$150免運" : "未滿$150"))")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    Spacer()
                                    Text(deliveryFee == 0 ? "免費" : "+ NT$ \(deliveryFee)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(deliveryFee == 0 ? AppTheme.primaryGreen : AppTheme.accentGold)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("應付總金額")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Text("NT$ \(finalTotal)")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 90)
                    }
                }
                
                // Bottom Submit Order Sticky Button
                VStack {
                    Button(action: {
                        if !cartItems.isEmpty {
                            SoundManager.shared.playOrderSuccessSound()
                            onCheckout()
                        }
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 15))
                            Text("確認點餐 ‧ 送出訂單")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Text("NT$ \(finalTotal)")
                                .font(.system(size: 18, weight: .black))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: cartItems.isEmpty ? [Color.gray, Color.gray] : [Color(hex: "008B47"), Color(hex: "006834")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: AppTheme.primaryGreen.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .disabled(cartItems.isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(AppTheme.cardBg(isDarkMode).opacity(0.95))
            }
            .navigationTitle("購物車與點餐明細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                }
            }
            .sheet(isPresented: $showCouponSheet) {
                CouponSelectSheet(
                    selectedCoupon: $selectedCoupon,
                    subtotal: subtotal,
                    isPresented: $showCouponSheet
                )
            }
            .sheet(isPresented: $showDeliverySetupSheet) {
                DeliverySetupSheet(deliveryInfo: $deliveryInfo, isPresented: $showDeliverySetupSheet)
            }
        }
    }
    
    private func handleItemAction(item: CartItem, action: CartRowAction) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        switch action {
        case .increment:
            cartItems[index].quantity += 1
        case .decrement:
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        case .delete:
            cartItems.remove(at: index)
        }
    }
}

enum CartRowAction {
    case increment, decrement, delete
}

// Cart Item Row Component
struct CartItemRowView: View {
    let item: CartItem
    let isDark: Bool
    let onAction: (CartRowAction) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Drink3DThumbnailView(style: item.drink.cupStyle, size: 45)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.drink.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary(isDark))
                
                Text(item.customizationSummary)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary(isDark))
                    .lineLimit(2)
                
                Text("NT$ \(item.unitPrice) / 杯")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("NT$ \(item.totalPrice)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary(isDark))
                
                HStack(spacing: 8) {
                    Button(action: {
                        SoundManager.shared.playTapSound()
                        onAction(.decrement)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppTheme.textSecondary(isDark))
                    }
                    
                    Text("\(item.quantity)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDark))
                    
                    Button(action: {
                        SoundManager.shared.playTapSound()
                        onAction(.increment)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
            }
        }
        .padding(10)
        .background(AppTheme.bg(isDark))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Coupon Select Sheet Component
struct CouponSelectSheet: View {
    @Binding var selectedCoupon: AppCoupon?
    let subtotal: Int
    @Binding var isPresented: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let coupons: [AppCoupon] = AppCoupon.sampleCoupons
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            selectedCoupon = nil
                            isPresented = false
                        }) {
                            HStack {
                                Text("不使用任何優惠券")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                if selectedCoupon == nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.primaryGreen)
                                }
                            }
                            .padding(14)
                            .background(AppTheme.cardBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        
                        ForEach(coupons) { coupon in
                            let isQualified = subtotal >= coupon.minSpend
                            Button(action: {
                                if isQualified {
                                    SoundManager.shared.playTapSound()
                                    selectedCoupon = coupon
                                    isPresented = false
                                }
                            }) {
                                HStack(spacing: 12) {
                                    VStack(spacing: 2) {
                                        Text(coupon.discountBadgeText)
                                            .font(.system(size: 16, weight: .black))
                                            .foregroundColor(.white)
                                        Text(coupon.badge)
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(Color(hex: "FEF08A"))
                                    }
                                    .frame(width: 80, height: 60)
                                    .background(isQualified ? AppTheme.primaryGreen : Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(coupon.title)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(isQualified ? AppTheme.textPrimary(isDarkMode) : AppTheme.textSecondary(isDarkMode))
                                        Text("滿 $\(coupon.minSpend) 即可折抵優惠")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedCoupon == coupon {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(AppTheme.primaryGreen)
                                    }
                                }
                                .padding(12)
                                .background(AppTheme.cardBg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .opacity(isQualified ? 1.0 : 0.5)
                            }
                            .disabled(!isQualified)
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .navigationTitle("選擇優惠券")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { isPresented = false }
                        .foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
