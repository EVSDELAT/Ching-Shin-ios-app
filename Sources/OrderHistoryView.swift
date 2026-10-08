import SwiftUI

struct OrderHistoryView: View {
    let orders: [CompletedOrder]
    @AppStorage("isDarkMode") private var isDarkMode = false
    var onReorder: ([CartItem]) -> Void
    
    // Filter out empty item orders if any
    var validOrders: [CompletedOrder] {
        orders.filter { !$0.items.isEmpty }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                if validOrders.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryGreen.opacity(0.1))
                                .frame(width: 100, height: 100)
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 48))
                                .foregroundColor(AppTheme.primaryGreen)
                        }
                        
                        Text("目前尚無歷史訂單")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                        
                        Text("完成點餐送出後，您的專屬訂單紀錄將會自動整理呈現於此！")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(validOrders) { order in
                                OrderHistoryCardView(
                                    order: order,
                                    isDarkMode: isDarkMode,
                                    onReorder: {
                                        onReorder(order.items)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 90)
                    }
                }
            }
            .navigationTitle("門市歷史訂單紀錄")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Dedicated Order History Card Component
struct OrderHistoryCardView: View {
    let order: CompletedOrder
    let isDarkMode: Bool
    let onReorder: () -> Void
    
    var totalCups: Int {
        order.items.reduce(0) { $0 + $1.quantity }
    }
    
    var cleanStatus: String {
        let text = order.status
        if text.contains("已完成") { return "已完成" }
        if text.contains("調配中") || text.contains("處理中") { return "調配中" }
        return text
    }
    
    var isTakeout: Bool {
        order.orderModeName == "外帶自取"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row: Store Name & Status Badges
            HStack(alignment: .top, spacing: 10) {
                // Store Icon
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGreen.opacity(0.12))
                        .frame(width: 38, height: 38)
                    Image(systemName: isTakeout ? "bag.fill" : "bicycle")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.primaryGreen)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.storeName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text(order.orderNo)
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        
                        Text("‧")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        
                        Text(order.dateString)
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                }
                
                Spacer()
                
                // Badges
                VStack(alignment: .trailing, spacing: 4) {
                    Text(cleanStatus)
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(AppTheme.primaryGreen.opacity(0.12))
                        .foregroundColor(AppTheme.primaryGreen)
                        .clipShape(Capsule())
                    
                    Text(order.orderModeName)
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.secondaryCardBg(isDarkMode))
                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            Divider()
                .background(AppTheme.border(isDarkMode))
            
            // Items List
            VStack(alignment: .leading, spacing: 12) {
                ForEach(order.items) { item in
                    HStack(alignment: .top, spacing: 10) {
                        // Bullet Cup Dot
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.primaryGreen)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(item.drink.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                
                                Spacer()
                                
                                Text("NT$ \(item.totalPrice)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            
                            HStack {
                                Text(item.customizationSummary)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    .lineLimit(2)
                                
                                Spacer()
                                
                                Text("x\(item.quantity)")
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 1)
                                    .background(AppTheme.secondaryCardBg(isDarkMode))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                }
            }
            
            Divider()
                .background(AppTheme.border(isDarkMode))
            
            // Footer Row: Total Quantity, Total Price & Reorder Button
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("共 \(totalCups) 杯飲品")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("實付金額")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        Text("NT$ \(order.totalPrice)")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    SoundManager.shared.playTapSound()
                    onReorder()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12, weight: .bold))
                        Text("再點一次")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(AppTheme.primaryGreen)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(AppTheme.primaryGreen.opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(AppTheme.primaryGreen.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBg(isDarkMode))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 3)
    }
}
