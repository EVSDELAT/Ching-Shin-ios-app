import SwiftUI

struct OrderProgressView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let orderItems: [CartItem]
    let storeName: String
    let orderModeName: String
    var onComplete: (CompletedOrder) -> Void
    
    @State private var currentStep: Int = 0
    @State private var progressValue: Double = 0.2
    @State private var isShakingCup: Bool = false
    @State private var isCompleted: Bool = false
    
    // User requested 5 exact steps:
    // 1. 訂單已接收
    // 2. 店家準備中
    // 3. 店家製作中
    // 4. 訂單已完成
    // 5. 可以取餐 / 外送中 (看是外送還是自取)
    var steps: [(String, String)] {
        let isTakeout = orderModeName == "外帶自取"
        let finalTitle = isTakeout ? "可以取餐" : "外送中"
        let finalDesc = isTakeout ? "飲品已在門市櫃檯等候，請出示畫面取餐！" : "外送專員已出發，正火速為您送達指定地址！"
        
        return [
            ("訂單已接收", "門市已接收並確認您的點餐需求"),
            ("店家準備中", "吧檯手已核對客製化茶湯與加料備品"),
            ("店家製作中", "專業吧檯手正在為您精準手搖調配..."),
            ("訂單已完成", "飲品皆已封口完成並貼上專屬標籤"),
            (finalTitle, finalDesc)
        ]
    }
    
    var totalPrice: Int {
        orderItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Progress Bar & Header
                        VStack(spacing: 8) {
                            ProgressView(value: progressValue)
                                .tint(AppTheme.primaryGreen)
                                .scaleEffect(x: 1, y: 2.2, anchor: .center)
                                .padding(.horizontal)
                            
                            HStack {
                                HStack(spacing: 4) {
                                    Image(systemName: orderModeName == "外送上門" ? "bicycle" : "bag.fill")
                                        .font(.caption)
                                    Text("[\(orderModeName)] \(storeName)")
                                        .font(.caption)
                                        .bold()
                                }
                                .foregroundColor(AppTheme.primaryGreen)
                                .lineLimit(1)
                                
                                Spacer()
                                
                                Text("製作進度 \(Int(progressValue * 100))%")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 12)
                        
                        // Animated Center Stage (Shaking cup during Step 3 "店家製作中")
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryGreen.opacity(0.1))
                                .frame(width: 190, height: 190)
                                .scaleEffect(isCompleted ? 1.08 : 1.0)
                                .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isCompleted)
                            
                            VStack(spacing: 12) {
                                if currentStep == 4 && orderModeName == "外送上門" {
                                    // Delivery Scooter Animation on Final Step
                                    VStack(spacing: 8) {
                                        Image(systemName: "bicycle.circle.fill")
                                            .font(.system(size: 80))
                                            .foregroundColor(AppTheme.primaryGreen)
                                        Text("🛵 外送專員正火速送達中")
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(AppTheme.primaryGreen)
                                    }
                                } else {
                                    ShakingCupView(
                                        isShaking: isShakingCup,
                                        drinkColor: AppTheme.primaryGreen,
                                        hasBoba: true,
                                        iceCount: 3,
                                        sizeMultiplier: 1.15
                                    )
                                    
                                    if isShakingCup {
                                        HStack(spacing: 4) {
                                            Image(systemName: "sparkles").foregroundColor(.orange)
                                            Text("吧檯手用力搖晃調配中...")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(AppTheme.primaryGreen)
                                            Image(systemName: "sparkles").foregroundColor(.orange)
                                        }
                                        .transition(.scale)
                                    } else if isCompleted {
                                        Text(orderModeName == "外帶自取" ? "🎉 飲品製作完成！可以取餐" : "🎉 飲品製作完成！已出發外送")
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(AppTheme.primaryGreen)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        
                        // Step-by-Step 5 Tracker Card
                        VStack(alignment: .leading, spacing: 14) {
                            ForEach(0..<steps.count, id: \.self) { idx in
                                HStack(alignment: .top, spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(idx <= currentStep ? AppTheme.primaryGreen : Color.gray.opacity(0.2))
                                            .frame(width: 28, height: 28)
                                        
                                        if idx < currentStep {
                                            Image(systemName: "checkmark")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(.white)
                                        } else {
                                            Text("\(idx + 1)")
                                                .font(.caption)
                                                .bold()
                                                .foregroundColor(idx == currentStep ? .white : .gray)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            Text(steps[idx].0)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(idx <= currentStep ? AppTheme.textPrimary(isDarkMode) : AppTheme.textSecondary(isDarkMode))
                                            
                                            if idx == currentStep && !isCompleted {
                                                Text("進行中")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 1)
                                                    .background(AppTheme.primaryGreen)
                                                    .foregroundColor(.white)
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        
                                        Text(steps[idx].1)
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding(16)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Bottom Done/Close Button
                        Button(action: {
                            let orderNo = "#CS-\(Int.random(in: 100000...999999))"
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                            let nowString = dateFormatter.string(from: Date())
                            
                            let newOrder = CompletedOrder(
                                orderNo: orderNo,
                                storeName: storeName,
                                orderModeName: orderModeName,
                                items: orderItems,
                                totalPrice: totalPrice,
                                dateString: nowString,
                                status: "已完成"
                            )
                            onComplete(newOrder)
                            dismiss()
                        }) {
                            Text(isCompleted ? "查看歷史訂單紀錄" : "完成（前往歷史訂單）")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppTheme.primaryGreen)
                                .clipShape(Capsule())
                                .shadow(color: AppTheme.primaryGreen.opacity(0.3), radius: 6, x: 0, y: 3)
                                .padding(.horizontal)
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("訂單追蹤與調配進度")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                }
            }
            .onAppear {
                startOrderSimulation()
            }
        }
    }
    
    private func startOrderSimulation() {
        // Step 1: 訂單已接收 (0.0s)
        currentStep = 0
        progressValue = 0.20
        isShakingCup = false
        
        // Step 2: 店家準備中 (1.2s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut) {
                currentStep = 1
                progressValue = 0.40
                isShakingCup = false
            }
        }
        
        // Step 3: 店家製作中 (2.5s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut) {
                currentStep = 2
                progressValue = 0.65
                isShakingCup = true
            }
        }
        
        // Step 4: 訂單已完成 (4.0s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut) {
                currentStep = 3
                progressValue = 0.85
                isShakingCup = false
            }
        }
        
        // Step 5: 可以取餐 / 外送中 (5.5s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            withAnimation(.easeInOut) {
                currentStep = 4
                progressValue = 1.00
                isShakingCup = false
                isCompleted = true
            }
        }
    }
}
