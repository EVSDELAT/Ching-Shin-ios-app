import SwiftUI

struct OrderTrackingView: View {
    @State private var mockOrder: Order = Order(
        id: "ord_101",
        orderNumber: "CS-8899",
        storeName: "清心福全 台北信義店",
        items: [
            CartItem(
                drink: MockData.sampleDrinks[0], // 隱藏版
                size: .large,
                sugar: .micro,
                ice: .lessIce,
                toppings: [Topping(id: "boba", name: "珍珠", price: 10), Topping(id: "coconut", name: "椰果", price: 10)],
                note: "微糖少冰",
                quantity: 2
            ),
            CartItem(
                drink: MockData.sampleDrinks[1], // 烏龍綠
                size: .large,
                sugar: .sugarFree,
                ice: .microIce,
                toppings: [],
                note: "無糖微冰",
                quantity: 1
            )
        ],
        totalPrice: 165,
        orderTime: Date(),
        status: .preparing,
        isDelivery: false,
        deliveryAddress: nil
    )
    
    @State private var pulsingBoba: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Order Status Card Header
                        VStack(spacing: 14) {
                            HStack {
                                Text("取餐號碼：\(mockOrder.orderNumber)")
                                    .font(.headline.monospaced())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(ChingShinTheme.lightGreen)
                                    .foregroundColor(ChingShinTheme.darkGreen)
                                    .cornerRadius(10)
                                Spacer()
                                Text(mockOrder.status.rawValue)
                                    .font(.subheadline.bold())
                                    .foregroundColor(ChingShinTheme.primaryGreen)
                            }
                            
                            // Visual Animated Boba Machine Indicator
                            ZStack {
                                Circle()
                                    .fill(ChingShinTheme.lightGreen.opacity(0.8))
                                    .frame(width: 90, height: 90)
                                
                                Text("🧋")
                                    .font(.system(size: 54))
                                    .scaleEffect(pulsingBoba ? 1.12 : 0.95)
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulsingBoba)
                            }
                            
                            VStack(spacing: 4) {
                                Text(mockOrder.status.rawValue)
                                    .font(.title2.bold())
                                Text("預計完成時間：10分鐘內")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Step Progress Bar
                            HStack(spacing: 4) {
                                ForEach(1...4, id: \.self) { step in
                                    let isCompleted = mockOrder.status.stepIndex >= step
                                    let isCurrent = mockOrder.status.stepIndex == step
                                    
                                    Capsule()
                                        .fill(isCompleted ? ChingShinTheme.primaryGreen : Color.gray.opacity(0.3))
                                        .frame(height: isCurrent ? 8 : 5)
                                        .animation(.spring(), value: mockOrder.status)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Interactive Demo Step Trigger
                            Button(action: advanceOrderStep) {
                                HStack(spacing: 6) {
                                    Image(systemName: "play.circle.fill")
                                    Text("⚡️ 點擊模擬推進製作進度 (Boss Demo)")
                                        .font(.caption.bold())
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(ChingShinTheme.goldYellow.opacity(0.25))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(ChingShinTheme.cardBackground)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        // Pickup QR Code Card
                        VStack(spacing: 12) {
                            Text("門市快速取餐條碼")
                                .font(.headline)
                            
                            // Mock Barcode Graphic
                            Image(systemName: "barcode")
                                .font(.system(size: 70))
                                .foregroundColor(.primary)
                            
                            Text("向店員出示此畫面即可完成領餐")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(ChingShinTheme.cardBackground)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Items Breakdown Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("訂單明細")
                                    .font(.headline)
                                Spacer()
                                Text(mockOrder.storeName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider()
                            
                            ForEach(mockOrder.items) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.drink.name)
                                            .font(.subheadline.bold())
                                        Text("\(item.size.rawValue) / \(item.sugar.shortName) / \(item.ice.rawValue)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        if !item.toppings.isEmpty {
                                            Text(item.toppings.map { $0.name }.joined(separator: "、"))
                                                .font(.caption2)
                                                .foregroundColor(ChingShinTheme.primaryGreen)
                                        }
                                    }
                                    Spacer()
                                    Text("× \(item.quantity)")
                                        .font(.subheadline.bold())
                                }
                                Divider()
                            }
                            
                            HStack {
                                Text("合計金額")
                                    .font(.headline)
                                Spacer()
                                Text("$\(mockOrder.totalPrice)")
                                    .font(.title3.bold())
                                    .foregroundColor(ChingShinTheme.primaryGreen)
                            }
                        }
                        .padding(20)
                        .background(ChingShinTheme.cardBackground)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("訂單即時追蹤")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                pulsingBoba = true
            }
        }
    }
    
    private func advanceOrderStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            switch mockOrder.status {
            case .received:
                mockOrder.status = .preparing
            case .preparing:
                mockOrder.status = .sealing
            case .sealing:
                mockOrder.status = .ready
            case .ready:
                mockOrder.status = .completed
            case .completed:
                mockOrder.status = .received
            }
        }
    }
}
