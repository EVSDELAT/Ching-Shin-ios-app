import SwiftUI

struct DrinkDetailView: View {
    let drink: Drink
    var onAddToCart: (CartItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSize: CupSize = .large
    @State private var selectedSugar: SugarLevel = .half5
    @State private var selectedIce: IceLevel = .lessIce
    @State private var selectedToppings: Set<Topping> = []
    @State private var quantity: Int = 1
    
    var unitPrice: Int {
        let basePrice = (selectedSize == .large) ? drink.priceL : (drink.priceM ?? drink.priceL)
        let toppingsPrice = selectedToppings.reduce(0, { $0 + $1.price })
        return basePrice + toppingsPrice
    }
    
    var totalPrice: Int {
        unitPrice * quantity
    }
    
    let sugarOptions: [SugarLevel] = SugarLevel.allCases
    let iceOptions: [IceLevel] = IceLevel.allCases
    let toppingOptions: [Topping] = Topping.allCases
    
    let toppingColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(hex: "F8F9FA").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Drink Header Card with Visual Preview
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "008B47").opacity(0.12), Color(hex: "008B47").opacity(0.04)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            HStack(spacing: 16) {
                                Drink3DThumbnailView(style: drink.cupStyle, size: 90)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(drink.name)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(Color(hex: "1F2937"))
                                        
                                        if drink.isHotItem {
                                            Text("HOT")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.red)
                                                .clipShape(Capsule())
                                        }
                                    }
                                    
                                    Text(drink.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "6B7280"))
                                        .lineLimit(2)
                                    
                                    HStack(spacing: 8) {
                                        Text("單杯單價:")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "9CA3AF"))
                                        Text("NT$ \(unitPrice)")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(Color(hex: "008B47"))
                                    }
                                    .padding(.top, 2)
                                }
                                
                                Spacer(minLength: 0)
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        
                        // Option Section 1: Cup Size (容量選擇)
                        DetailOptionGroup(title: "容量大小", subtitle: "選擇容量規格") {
                            HStack(spacing: 12) {
                                if let pM = drink.priceM {
                                    SelectableChip(
                                        title: "中杯 (M)",
                                        subtitle: "NT$ \(pM)",
                                        isSelected: selectedSize == .medium
                                    ) {
                                        SoundManager.shared.playTapSound()
                                        selectedSize = .medium
                                    }
                                }
                                
                                SelectableChip(
                                    title: "大杯 (L)",
                                    subtitle: "NT$ \(drink.priceL)",
                                    isSelected: selectedSize == .large
                                ) {
                                    SoundManager.shared.playTapSound()
                                    selectedSize = .large
                                }
                            }
                        }
                        
                        // Option Section 2: Sugar Level (甜度選擇)
                        DetailOptionGroup(title: "甜度選擇", subtitle: "本市使用台糖甘蔗液糖") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(sugarOptions, id: \.self) { sugar in
                                    SelectableChip(
                                        title: sugar.rawValue,
                                        subtitle: nil,
                                        isSelected: selectedSugar == sugar
                                    ) {
                                        SoundManager.shared.playTapSound()
                                        selectedSugar = sugar
                                    }
                                }
                            }
                        }
                        
                        // Option Section 3: Ice Level (冰熱選擇)
                        DetailOptionGroup(title: "冰熱選擇", subtitle: "溫度調整") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(iceOptions, id: \.self) { ice in
                                    SelectableChip(
                                        title: ice.rawValue,
                                        subtitle: nil,
                                        isSelected: selectedIce == ice
                                    ) {
                                        SoundManager.shared.playTapSound()
                                        selectedIce = ice
                                    }
                                }
                            }
                        }
                        
                        // Option Section 4: Toppings (加料選擇)
                        DetailOptionGroup(title: "加料選擇 (額外加價)", subtitle: "可複選多種配料") {
                            LazyVGrid(columns: toppingColumns, spacing: 10) {
                                ForEach(toppingOptions, id: \.self) { topping in
                                    ToppingChipView(
                                        topping: topping,
                                        isSelected: selectedToppings.contains(topping),
                                        onToggle: {
                                            SoundManager.shared.playTapSound()
                                            if selectedToppings.contains(topping) {
                                                selectedToppings.remove(topping)
                                            } else {
                                                selectedToppings.insert(topping)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Option Section 5: Quantity (購買數量)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("購買數量")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "1F2937"))
                                Spacer()
                                
                                HStack(spacing: 16) {
                                    Button(action: {
                                        if quantity > 1 {
                                            SoundManager.shared.playTapSound()
                                            quantity -= 1
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(quantity > 1 ? Color(hex: "E5E7EB") : Color(hex: "F3F4F6"))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "minus")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(quantity > 1 ? Color(hex: "1F2937") : Color(hex: "9CA3AF"))
                                        }
                                    }
                                    
                                    Text("\(quantity)")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(Color(hex: "1F2937"))
                                        .frame(minWidth: 24)
                                    
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        quantity += 1
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "008B47"))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "plus")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
                
                // Sticky Bottom Cart Button
                VStack {
                    Button(action: {
                        SoundManager.shared.playAddToCartSound()
                        let newItem = CartItem(
                            drink: drink,
                            size: selectedSize,
                            sugar: selectedSugar,
                            ice: selectedIce,
                            toppings: selectedToppings,
                            quantity: quantity
                        )
                        onAddToCart(newItem)
                        dismiss()
                    }) {
                        HStack {
                            Text("加入購物車")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("共 NT$ \(totalPrice)")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                        }
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
                        .shadow(color: Color(hex: "008B47").opacity(0.35), radius: 10, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .background(Color.white.opacity(0.95))
            }
            .navigationTitle("飲料客製化")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "6B7280"))
                }
            }
        }
    }
}

struct ToppingChipView: View {
    let topping: Topping
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        SelectableChip(
            title: "\(topping.rawValue)",
            subtitle: "(+\(topping.price))",
            isSelected: isSelected,
            action: onToggle
        )
    }
}

struct DetailOptionGroup<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    
    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            
            content
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

struct SelectableChip: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 11))
                }
            }
            .foregroundColor(isSelected ? .white : Color(hex: "374151"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(isSelected ? Color(hex: "008B47") : Color(hex: "F3F4F6"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "008B47") : Color.clear, lineWidth: 1.5)
            )
        }
    }
}
