import SwiftUI

struct DrinkDetailView: View {
    let drink: Drink
    var onAddToCart: (CartItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSize: CupSize = .large
    @State private var selectedSugar: SugarLevel = .half5
    @State private var selectedIce: IceLevel = .lessIce
    @State private var selectedToppings: Set<Topping> = [.boba]
    @State private var quantity: Int = 1
    @State private var isCupShaking: Bool = false
    
    var unitPrice: Int {
        let base = (selectedSize == .medium && drink.priceM != nil) ? drink.priceM! : drink.priceL
        let toppingCost = selectedToppings.reduce(0) { $0 + $1.price }
        return base + toppingCost
    }
    
    var totalPrice: Int {
        unitPrice * quantity
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Animated Cup View
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "00A550").opacity(0.12), Color(hex: "008B47").opacity(0.04)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            ShakingCupView(
                                isShaking: isCupShaking,
                                drinkColor: Color(hex: "008B47"),
                                hasBoba: selectedToppings.contains(.boba),
                                iceCount: selectedIce == .noIce || selectedIce == .hot ? 0 : (selectedIce == .regular ? 4 : 2),
                                sizeMultiplier: selectedSize == .large ? 1.15 : 1.0
                            )
                            .onTapGesture {
                                triggerCupShake()
                            }
                            
                            Text("👆 點擊杯子手搖體驗！")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Drink Title & Description
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(drink.name)
                                .font(.title2)
                                .bold()
                            
                            if drink.isHotItem {
                                Text("HOT 招牌")
                                    .font(.caption2)
                                    .bold()
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                            
                            Text("NT$ \(unitPrice)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color(hex: "008B47"))
                        }
                        
                        Text(drink.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // Option Sections
                    VStack(alignment: .leading, spacing: 18) {
                        // Cup Size
                        OptionSection(title: "容量大小", subtitle: "選擇容量") {
                            HStack(spacing: 12) {
                                if let pM = drink.priceM {
                                    SelectableChip(
                                        title: "中杯 (M) $\(pM)",
                                        isSelected: selectedSize == .medium
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedSize = .medium
                                            triggerCupShake()
                                        }
                                    }
                                }
                                
                                SelectableChip(
                                    title: "大杯 (L) $\(drink.priceL)",
                                    isSelected: selectedSize == .large
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedSize = .large
                                        triggerCupShake()
                                    }
                                }
                            }
                        }
                        
                        // Sugar Level (符合官方甜度圖示)
                        OptionSection(title: "糖量選擇 (本市使用台糖甘蔗液糖)", subtitle: "可微調") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(SugarLevel.allCases) { sugar in
                                        SelectableChip(
                                            title: sugar.shortName,
                                            isSelected: selectedSugar == sugar
                                        ) {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedSugar = sugar
                                                triggerCupShake()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Ice Level (符合官方冰量圖示)
                        OptionSection(title: "冰熱選擇", subtitle: "溫度調整") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(IceLevel.allCases) { ice in
                                        SelectableChip(
                                            title: ice.shortName,
                                            icon: ice.iconName,
                                            isSelected: selectedIce == ice
                                        ) {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedIce = ice
                                                triggerCupShake()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Toppings (符合官方圖片完整 12 種加料)
                        OptionSection(title: "加料選擇 (額外加價)", subtitle: "可複選") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(Topping.allCases) { topping in
                                    let isSelected = selectedToppings.contains(topping)
                                    SelectableChip(
                                        title: topping.rawValue,
                                        isSelected: isSelected
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            if isSelected {
                                                selectedToppings.remove(topping)
                                            } else {
                                                selectedToppings.insert(topping)
                                            }
                                            triggerCupShake()
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Quantity Stepper
                        HStack {
                            Text("購買數量")
                                .font(.headline)
                            Spacer()
                            HStack(spacing: 16) {
                                Button(action: {
                                    if quantity > 1 {
                                        withAnimation { quantity -= 1 }
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(quantity > 1 ? Color(hex: "008B47") : .gray.opacity(0.4))
                                }
                                
                                Text("\(quantity)")
                                    .font(.title3)
                                    .bold()
                                    .frame(minWidth: 30)
                                
                                Button(action: {
                                    withAnimation { quantity += 1 }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("飲料客製化 (清心福全)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    let item = CartItem(
                        drink: drink,
                        size: selectedSize,
                        sugar: selectedSugar,
                        ice: selectedIce,
                        toppings: selectedToppings,
                        quantity: quantity
                    )
                    onAddToCart(item)
                    dismiss()
                }) {
                    HStack {
                        Text("加入購物車")
                            .font(.headline)
                            .bold()
                        Spacer()
                        Text("共 NT$ \(totalPrice)")
                            .font(.title3)
                            .bold()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "00A550"), Color(hex: "008B47")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color(hex: "008B47").opacity(0.4), radius: 8, x: 0, y: 4)
                    .padding()
                }
                .background(.ultraThinMaterial)
            }
        }
    }
    
    private func triggerCupShake() {
        isCupShaking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isCupShaking = false
        }
    }
}

// MARK: - Helper UI Components
struct OptionSection<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            content()
        }
    }
}

struct SelectableChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color(hex: "008B47") : Color.gray.opacity(0.12))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color(hex: "008B47") : Color.clear, lineWidth: 1.5)
            )
        }
    }
}
