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
    @State private var isShakingCup: Bool = true
    @State private var isCompleted: Bool = false
    
    let steps = [
        ("訂單已接收", "門市已收到您的點餐需求"),
        ("手遙調配中", "專業吧檯手正在為您精準搖調飲品..."),
        ("封口包裝完成", "已完成封口並貼上專屬甜度冰量標籤"),
        ("準備完成！", "請出示畫面至門市取餐，祝您享用愉快！")
    ]
    
    var totalPrice: Int {
        orderItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Progress Bar
                    VStack(spacing: 8) {
                        ProgressView(value: progressValue)
                            .tint(AppTheme.primaryGreen)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("[\(orderModeName)] \(storeName)")
                                .font(.caption)
                                .bold()
                                .foregroundColor(AppTheme.primaryGreen)
                                .lineLimit(1)
                            Spacer()
                            Text("製作進度 \(Int(progressValue * 100))%")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 12)
                    
                    // Animated Shaking Cup Center Stage
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryGreen.opacity(0.1))
                            .frame(width: 200, height: 200)
                            .scaleEffect(isCompleted ? 1.08 : 1.0)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isCompleted)
                        
                        VStack(spacing: 12) {
                            ShakingCupView(
                                isShaking: isShakingCup,
                                drinkColor: AppTheme.primaryGreen,
                                hasBoba: true,
                                iceCount: 3,
                                sizeMultiplier: 1.2
                            )
                            
                            if isShakingCup {
                                HStack(spacing: 4) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.orange)
                                    Text("吧檯手用力搖晃調配中...")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.orange)
                                }
                                .transition(.scale)
                            } else if isCompleted {
                                Text("🎉 製作完成！已加入歷史訂單")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                    }
                    .frame(height: 220)
                    
                    // Step-by-Step Tracker Card
                    VStack(alignment: .leading, spacing: 16) {
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
                                    Text(steps[idx].0)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(idx <= currentStep ? AppTheme.textPrimary(isDarkMode) : AppTheme.textSecondary(isDarkMode))
                                    
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
                    
                    Spacer()
                    
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
                    .padding(.bottom, 16)
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
        currentStep = 0
        progressValue = 0.25
        isShakingCup = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut) {
                currentStep = 1
                progressValue = 0.55
                isShakingCup = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut) {
                currentStep = 2
                progressValue = 0.85
                isShakingCup = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeInOut) {
                currentStep = 3
                progressValue = 1.0
                isShakingCup = false
                isCompleted = true
            }
        }
    }
}
