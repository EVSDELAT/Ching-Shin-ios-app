import SwiftUI

struct OrderProgressView: View {
    var orderItems: [CartItem]
    var storeName: String
    var onComplete: (CompletedOrder) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStep: Int = 1
    @State private var progressValue: Double = 0.25
    @State private var isShakingCup: Bool = true
    @State private var isCompleted: Bool = false
    
    let steps = [
        ("訂單已接收", "門市已收到您的點餐需求"),
        ("手搖調配中", "專業吧檯手正在為您精準搖調飲品..."),
        ("封口包裝完成", "已完成封口並貼上專屬甜度冰量標籤"),
        ("準備完成！", "請出示畫面至門市取餐，祝您享用愉快！")
    ]
    
    var totalPrice: Int {
        orderItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Progress Bar
                VStack(spacing: 8) {
                    ProgressView(value: progressValue)
                        .tint(Color(hex: "008B47"))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("\(storeName) ‧ 預計取餐 8 分鐘")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color(hex: "008B47"))
                        Spacer()
                        Text("製作進度 \(Int(progressValue * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                // Animated Shaking Cup Center Stage
                ZStack {
                    Circle()
                        .fill(Color(hex: "00A550").opacity(0.1))
                        .frame(width: 220, height: 220)
                        .scaleEffect(isCompleted ? 1.1 : 1.0)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isCompleted)
                    
                    VStack(spacing: 12) {
                        ShakingCupView(
                            isShaking: isShakingCup,
                            drinkColor: Color(hex: "008B47"),
                            hasBoba: true,
                            iceCount: 3,
                            sizeMultiplier: 1.3
                        )
                        
                        if isShakingCup {
                            HStack(spacing: 4) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.orange)
                                Text("吧檯手用力搖晃調配中...")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(Color(hex: "008B47"))
                                Image(systemName: "sparkles")
                                    .foregroundColor(.orange)
                            }
                            .transition(.scale)
                        } else if isCompleted {
                            Text("🎉 製作完成！已加入歷史訂單")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color(hex: "008B47"))
                        }
                    }
                }
                .frame(height: 240)
                
                // Step-by-Step Tracker Card
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(0..<steps.count, id: \.self) { idx in
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(idx <= currentStep ? Color(hex: "008B47") : Color.gray.opacity(0.2))
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
                                    .font(.headline)
                                    .foregroundColor(idx <= currentStep ? .primary : .secondary)
                                
                                Text(steps[idx].1)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 18))
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
                        items: orderItems,
                        totalPrice: totalPrice,
                        dateString: nowString,
                        status: "製作完成 (可取餐)"
                    )
                    onComplete(newOrder)
                    dismiss()
                }) {
                    Text(isCompleted ? "查看歷史訂單紀錄" : "完成（前往歷史訂單）")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "008B47"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("訂單追蹤與調配進度")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                startOrderSimulation()
            }
        }
    }
    
    private func startOrderSimulation() {
        currentStep = 0
        progressValue = 0.25
        isShakingCup = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut) {
                currentStep = 1
                progressValue = 0.55
                isShakingCup = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut) {
                currentStep = 2
                progressValue = 0.85
                isShakingCup = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation(.easeInOut) {
                currentStep = 3
                progressValue = 1.0
                isShakingCup = false
                isCompleted = true
            }
        }
    }
}
