import SwiftUI

struct CartSheet: View {
    @Binding var cartItems: [CartItem]
    let currentStore: Store
    @Environment(\.dismiss) var dismiss
    
    @State private var isDelivery: Bool = false
    @State private var deliveryAddress: String = "台北市信義區松壽路12號 5樓"
    @State private var appliedCoupon: Coupon? = MockData.sampleCoupons.first
    @State private var isShowingCheckout: Bool = false
    @State private var isShowingCoupons: Bool = false
    
    var subtotal: Int {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var discount: Int {
        if let coupon = appliedCoupon, subtotal >= coupon.minSpend {
            return coupon.discountAmount
        }
        return 0
    }
    
    var deliveryFee: Int {
        isDelivery ? 35 : 0
    }
    
    var finalTotal: Int {
        max(0, subtotal - discount + deliveryFee)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Delivery or Self-Pickup Toggle
                            Picker("取餐方式", selection: $isDelivery) {
                                Text("🥤 門市外帶自取").tag(false)
                                Text("🛵 外送到府").tag(true)
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            .padding(.top, 12)
                            
                            // Store / Address Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: isDelivery ? "figure.walk.arrival" : "storefront.fill")
                                        .foregroundColor(ChingShinTheme.primaryGreen)
                                    Text(isDelivery ? "外送地址" : "取餐門市")
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                if isDelivery {
                                    TextField("請輸入外送地址", text: $deliveryAddress)
                                        .textFieldStyle(.roundedBorder)
                                } else {
                                    Text(currentStore.name)
                                        .font(.subheadline.bold())
                                    Text(currentStore.address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(16)
                            .background(ChingShinTheme.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
                            // Item List Card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("點餐清單 (\(cartItems.count))")
                                        .font(.headline)
                                    Spacer()
                                    Button("清空購物車") {
                                        withAnimation {
                                            cartItems.removeAll()
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                                
                                Divider()
                                
                                ForEach(cartItems.indices, id: \.self) { index in
                                    let item = cartItems[index]
                                    HStack(alignment: .top, spacing: 12) {
                                        Text(item.drink.imageEmoji)
                                            .font(.system(size: 38))
                                            .padding(8)
                                            .background(ChingShinTheme.lightGreen.opacity(0.5))
                                            .cornerRadius(12)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(item.drink.name)
                                                    .font(.subheadline.bold())
                                                Text("(\(item.size.rawValue))")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Text("\(item.sugar.shortName) / \(item.ice.rawValue)")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            
                                            if !item.toppings.isEmpty {
                                                Text("加料：" + item.toppings.map { $0.name }.joined(separator: "、"))
                                                    .font(.caption2)
                                                    .foregroundColor(ChingShinTheme.primaryGreen)
                                            }
                                            
                                            if !item.note.isEmpty {
                                                Text("備註：\(item.note)")
                                                    .font(.caption2)
                                                    .foregroundColor(.orange)
                                            }
                                            
                                            Text("$\(item.unitPrice) × \(item.quantity) = $\(item.totalPrice)")
                                                .font(.caption.bold())
                                                .foregroundColor(.primary)
                                                .padding(.top, 2)
                                        }
                                        
                                        Spacer()
                                        
                                        // Quantity Controls
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                if cartItems[index].quantity > 1 {
                                                    cartItems[index].quantity -= 1
                                                } else {
                                                    cartItems.remove(at: index)
                                                }
                                            }) {
                                                Image(systemName: "minus.square.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("\(item.quantity)")
                                                .font(.subheadline.bold())
                                            
                                            Button(action: {
                                                cartItems[index].quantity += 1
                                            }) {
                                                Image(systemName: "plus.square.fill")
                                                    .font(.title3)
                                                    .foregroundColor(ChingShinTheme.primaryGreen)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    
                                    if index < cartItems.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                            .padding(16)
                            .background(ChingShinTheme.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
                            // Coupon Selection Card
                            HStack {
                                Image(systemName: "ticket.fill")
                                    .foregroundColor(ChingShinTheme.goldYellow)
                                Text(appliedCoupon != nil ? "折價券：\(appliedCoupon!.title)" : "選擇優惠券")
                                    .font(.subheadline.bold())
                                Spacer()
                                Button(appliedCoupon != nil ? "變更" : "選擇") {
                                    isShowingCoupons = true
                                }
                                .font(.caption.bold())
                                .foregroundColor(ChingShinTheme.primaryGreen)
                            }
                            .padding(16)
                            .background(ChingShinTheme.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
                            // Billing Summary Card
                            VStack(spacing: 8) {
                                SummaryRow(label: "小計", value: "$\(subtotal)")
                                if appliedCoupon != nil {
                                    SummaryRow(label: "優惠券折抵", value: "-$\(discount)", color: ChingShinTheme.accentRed)
                                }
                                if isDelivery {
                                    SummaryRow(label: "外送服務費", value: "+$\(deliveryFee)")
                                }
                                Divider()
                                SummaryRow(label: "實付金額", value: "$\(finalTotal)", isBold: true)
                            }
                            .padding(16)
                            .background(ChingShinTheme.cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 100)
                    }
                    
                    // Fixed Checkout Button
                    VStack {
                        Button(action: {
                            isShowingCheckout = true
                        }) {
                            HStack {
                                Text("前往結帳 (實付 $\(finalTotal))")
                                    .font(.headline.bold())
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title3)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ChingShinTheme.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(18)
                            .shadow(color: ChingShinTheme.primaryGreen.opacity(0.3), radius: 8, y: 4)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
                }
            }
            .navigationTitle("購物車明細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("關閉") { dismiss() }
                }
            }
            .sheet(isPresented: $isShowingCheckout) {
                CheckoutView(
                    cartItems: cartItems,
                    store: currentStore,
                    totalAmount: finalTotal,
                    isDelivery: isDelivery,
                    deliveryAddress: isDelivery ? deliveryAddress : nil
                ) {
                    cartItems.removeAll()
                    dismiss()
                }
            }
            .sheet(isPresented: $isShowingCoupons) {
                CouponPickerSheet(appliedCoupon: $appliedCoupon)
            }
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    var color: Color = .primary
    var isBold: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .headline : .subheadline)
                .foregroundColor(isBold ? .primary : .secondary)
            Spacer()
            Text(value)
                .font(isBold ? .title3.bold() : .subheadline.bold())
                .foregroundColor(color)
        }
    }
}

struct CouponPickerSheet: View {
    @Binding var appliedCoupon: Coupon?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(MockData.sampleCoupons) { coupon in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coupon.title)
                            .font(.headline)
                        Text(coupon.discountText)
                            .font(.subheadline)
                            .foregroundColor(ChingShinTheme.accentRed)
                        Text("效期至：\(coupon.validUntil)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if appliedCoupon?.id == coupon.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(ChingShinTheme.primaryGreen)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    appliedCoupon = coupon
                    dismiss()
                }
            }
            .navigationTitle("選擇折價券")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("不使用") {
                        appliedCoupon = nil
                        dismiss()
                    }
                }
            }
        }
    }
}
