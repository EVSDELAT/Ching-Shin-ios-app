import SwiftUI

struct CheckoutView: View {
    let cartItems: [CartItem]
    let store: Store
    let totalAmount: Int
    let isDelivery: Bool
    let deliveryAddress: String?
    var onOrderCompleted: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var paymentMethod: String = "LINE Pay"
    @State private var invoiceType: String = "手機條碼載具"
    @State private var carrierCode: String = "/CHING168"
    @State private var isSubmitting: Bool = false
    @State private var isOrderSuccess: Bool = false
    @State private var createdOrder: Order? = nil
    
    let paymentOptions = [
        ("LINE Pay", "green", "dollarsign.square.fill"),
        ("Apple Pay", "black", "apple.logo"),
        ("ChingShin Pay (會員隨手付)", "emerald", "creditcard.fill"),
        ("門市現場付款 (現金/刷卡)", "gray", "banknote.fill")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                if isOrderSuccess, let order = createdOrder {
                    OrderSuccessCelebrationView(order: order) {
                        onOrderCompleted()
                        dismiss()
                    }
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(spacing: 16) {
                                // Header Summary Card
                                VStack(spacing: 8) {
                                    Text("結帳金額")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("$\(totalAmount)")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(ChingShinTheme.primaryGreen)
                                    
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(.orange)
                                        Text("預計準備時間：約 15~20 分鐘")
                                            .font(.caption.bold())
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(ChingShinTheme.cardBackground)
                                .cornerRadius(20)
                                .padding(.horizontal)
                                .padding(.top, 12)
                                
                                // Payment Method Selection Card
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("付款方式 (Payment Method)")
                                        .font(.headline)
                                    
                                    ForEach(paymentOptions, id: \.0) { option in
                                        HStack {
                                            Image(systemName: option.2)
                                                .font(.title3)
                                                .foregroundColor(ChingShinTheme.primaryGreen)
                                                .frame(width: 32)
                                            
                                            Text(option.0)
                                                .font(.subheadline.bold())
                                            
                                            Spacer()
                                            
                                            if paymentMethod == option.0 {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(ChingShinTheme.primaryGreen)
                                            }
                                        }
                                        .padding(14)
                                        .background(paymentMethod == option.0 ? ChingShinTheme.lightGreen : Color(UIColor.tertiarySystemGroupedBackground))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(paymentMethod == option.0 ? ChingShinTheme.primaryGreen : Color.clear, lineWidth: 1.5)
                                        )
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                paymentMethod = option.0
                                            }
                                        }
                                    }
                                }
                                .padding(16)
                                .background(ChingShinTheme.cardBackground)
                                .cornerRadius(20)
                                .padding(.horizontal)
                                
                                // Invoice Carrier Card
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("電子發票設定")
                                        .font(.headline)
                                    
                                    Picker("發票載具", selection: $invoiceType) {
                                        Text("手機條碼").tag("手機條碼載具")
                                        Text("會員載具").tag("會員載具")
                                        Text("雲端發票").tag("雲端發票")
                                    }
                                    .pickerStyle(.segmented)
                                    
                                    if invoiceType == "手機條碼載具" {
                                        HStack {
                                            Image(systemName: "qrcode")
                                                .foregroundColor(.gray)
                                            TextField("請輸入手機條碼載具", text: $carrierCode)
                                                .font(.subheadline.monospaced())
                                        }
                                        .padding(10)
                                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(16)
                                .background(ChingShinTheme.cardBackground)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                            .padding(.bottom, 100)
                        }
                        
                        // Bottom Submit Button
                        VStack {
                            Button(action: processOrderSubmit) {
                                HStack(spacing: 10) {
                                    if isSubmitting {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "checkmark.seal.fill")
                                        Text("確認下單並支付 $\(totalAmount)")
                                            .font(.headline.bold())
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(ChingShinTheme.primaryGreen)
                                .foregroundColor(.white)
                                .cornerRadius(18)
                                .shadow(color: ChingShinTheme.primaryGreen.opacity(0.3), radius: 8, y: 4)
                            }
                            .disabled(isSubmitting)
                            .padding()
                            .background(.ultraThinMaterial)
                        }
                    }
                }
            }
            .navigationTitle("確認訂單與付款")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !isOrderSuccess {
                        Button("取消") { dismiss() }
                    }
                }
            }
        }
    }
    
    private func processOrderSubmit() {
        withAnimation {
            isSubmitting = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let orderNum = "CS-\(Int.random(in: 1000...9999))"
            let newOrder = Order(
                id: UUID().uuidString,
                orderNumber: orderNum,
                storeName: store.name,
                items: cartItems,
                totalPrice: totalAmount,
                orderTime: Date(),
                status: .received,
                isDelivery: isDelivery,
                deliveryAddress: deliveryAddress
            )
            createdOrder = newOrder
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isSubmitting = false
                isOrderSuccess = true
            }
        }
    }
}

// MARK: - Order Success Celebration Screen
struct OrderSuccessCelebrationView: View {
    let order: Order
    let onFinish: () -> Void
    
    @State private var scale: CGFloat = 0.6
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ChingShinTheme.lightGreen)
                    .frame(width: 140, height: 140)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(ChingShinTheme.primaryGreen)
                    .scaleEffect(scale)
            }
            
            VStack(spacing: 8) {
                Text("🎉 訂單已成功送出！")
                    .font(.title.bold())
                    .foregroundColor(ChingShinTheme.darkGreen)
                
                Text("取餐號碼：\(order.orderNumber)")
                    .font(.title2.monospaced().bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(ChingShinTheme.goldYellow.opacity(0.3))
                    .cornerRadius(12)
                
                Text("\(order.storeName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("訂單內容")
                        .font(.headline)
                    Spacer()
                    Text("\(order.items.count) 項商品")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Divider()
                ForEach(order.items) { item in
                    HStack {
                        Text("\(item.drink.name) (\(item.size.rawValue))")
                            .font(.subheadline.bold())
                        Spacer()
                        Text("× \(item.quantity)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Divider()
                HStack {
                    Text("實付金額")
                        .font(.headline)
                    Spacer()
                    Text("$\(order.totalPrice)")
                        .font(.title3.bold())
                        .foregroundColor(ChingShinTheme.primaryGreen)
                }
            }
            .padding(20)
            .background(ChingShinTheme.cardBackground)
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: onFinish) {
                Text("回到首頁 & 追蹤訂單進度")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ChingShinTheme.primaryGreen)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .shadow(color: ChingShinTheme.primaryGreen.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }
}
