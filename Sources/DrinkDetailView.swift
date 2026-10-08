import SwiftUI

struct DrinkDetailView: View {
    let drink: Drink
    var onAddToCart: (CartItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedSize: CupSize = .large
    @State private var selectedSugar: SugarLevel = .half5
    @State private var selectedIce: IceLevel = .lessIce
    @State private var selectedToppings: Set<Topping> = []
    @State private var noteText: String = ""
    @State private var quantity: Int = 1
    @State private var isToppingsExpanded: Bool = false
    
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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 10) {
                    // Compact Drink Header Card
                    HStack(spacing: 12) {
                        Drink3DThumbnailView(style: drink.cupStyle, size: 60)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(drink.name)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                
                                if drink.isHotItem {
                                    Text("HOT")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(Color.red)
                                        .clipShape(Capsule())
                                }
                            }
                            
                            Text(drink.description)
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                .lineLimit(1)
                            
                            HStack(spacing: 6) {
                                Text("單價:")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                Text("NT$ \(unitPrice)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(AppTheme.cardBg(isDarkMode))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
                    
                    // Section 1: Cup Size (容量規格)
                    CompactOptionRow(title: "容量規格") {
                        HStack(spacing: 8) {
                            if let pM = drink.priceM {
                                CompactChip(
                                    title: "中杯 (M) $\(pM)",
                                    isSelected: selectedSize == .medium,
                                    isDark: isDarkMode
                                ) {
                                    SoundManager.shared.playTapSound()
                                    selectedSize = .medium
                                }
                            }
                            
                            CompactChip(
                                title: "大杯 (L) $\(drink.priceL)",
                                isSelected: selectedSize == .large,
                                isDark: isDarkMode
                            ) {
                                SoundManager.shared.playTapSound()
                                selectedSize = .large
                            }
                        }
                    }
                    
                    // Section 2: Sugar Level (甜度選擇)
                    CompactOptionRow(title: "甜度選擇") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                            ForEach(sugarOptions, id: \.self) { sugar in
                                CompactChip(
                                    title: sugar.rawValue,
                                    isSelected: selectedSugar == sugar,
                                    isDark: isDarkMode
                                ) {
                                    SoundManager.shared.playTapSound()
                                    selectedSugar = sugar
                                }
                            }
                        }
                    }
                    
                    // Section 3: Ice Level (冰熱選擇)
                    CompactOptionRow(title: "冰熱選擇") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                            ForEach(iceOptions, id: \.self) { ice in
                                CompactChip(
                                    title: ice.rawValue,
                                    isSelected: selectedIce == ice,
                                    isDark: isDarkMode
                                ) {
                                    SoundManager.shared.playTapSound()
                                    selectedIce = ice
                                }
                            }
                        }
                    }
                    
                    // Section 4: Toppings (Expandable Accordion) - Requirement 1: Removed "(珍珠/椰果...)" label
                    VStack(alignment: .leading, spacing: 6) {
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            withAnimation(.spring(response: 0.3)) {
                                isToppingsExpanded.toggle()
                            }
                        }) {
                            HStack {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Text("加購配料")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    
                                    if !selectedToppings.isEmpty {
                                        Text("已選\(selectedToppings.count)種")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(AppTheme.primaryGreen)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: isToppingsExpanded ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            .padding(10)
                            .background(AppTheme.cardBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        if isToppingsExpanded {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                                ForEach(toppingOptions, id: \.self) { topping in
                                    let isSelected = selectedToppings.contains(topping)
                                    CompactChip(
                                        title: "\(topping.cleanName) (+\(topping.price))",
                                        isSelected: isSelected,
                                        isDark: isDarkMode
                                    ) {
                                        SoundManager.shared.playTapSound()
                                        if isSelected {
                                            selectedToppings.remove(topping)
                                        } else {
                                            selectedToppings.insert(topping)
                                        }
                                    }
                                }
                            }
                            .padding(8)
                            .background(AppTheme.cardBg(isDarkMode).opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal, 14)
                    
                    // Section 5: Custom Remark / Note Input - Requirement 1: User manual note field
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.primaryGreen)
                            Text("客製化備註 (選填)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        }
                        
                        TextField("例如：珍珠多一點、厚奶、分開裝...", text: $noteText)
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(AppTheme.inputBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                    }
                    .padding(8)
                    .background(AppTheme.cardBg(isDarkMode))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 14)
                    
                    Spacer(minLength: 0)
                }
                .padding(.bottom, 75)
                
                // Sticky Action Bar (Quantity + Add to Cart Button)
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        // Quantity Stepper
                        HStack(spacing: 12) {
                            Button(action: {
                                if quantity > 1 {
                                    SoundManager.shared.playTapSound()
                                    quantity -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(quantity > 1 ? AppTheme.primaryGreen : Color.gray.opacity(0.4))
                            }
                            
                            Text("\(quantity)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                quantity += 1
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(AppTheme.border(isDarkMode), lineWidth: 1))
                        
                        // Add to Cart Button
                        Button(action: {
                            SoundManager.shared.playAddToCartSound()
                            let newItem = CartItem(
                                drink: drink,
                                size: selectedSize,
                                sugar: selectedSugar,
                                ice: selectedIce,
                                toppings: selectedToppings,
                                note: noteText,
                                quantity: quantity
                            )
                            onAddToCart(newItem)
                            dismiss()
                        }) {
                            HStack {
                                Text("加入購物車")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("共 NT$ \(totalPrice)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color(hex: "008B47").opacity(0.35), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(AppTheme.cardBg(isDarkMode))
                    .shadow(color: Color.black.opacity(isDarkMode ? 0.4 : 0.1), radius: 8, x: 0, y: -2)
                }
            }
            .navigationTitle("飲料客製化")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                }
            }
        }
    }
}

// Compact Option Section Container
struct CompactOptionRow<Content: View>: View {
    let title: String
    let content: Content
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(AppTheme.textSecondary(isDarkMode))
            
            content
        }
        .padding(8)
        .background(AppTheme.cardBg(isDarkMode))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.03), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 14)
    }
}

// Compact Chip Button
struct CompactChip: View {
    let title: String
    let isSelected: Bool
    let isDark: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary(isDark))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .padding(.horizontal, 4)
                .background(isSelected ? AppTheme.primaryGreen : AppTheme.inputBg(isDark))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? AppTheme.primaryGreen : AppTheme.border(isDark), lineWidth: 1)
                )
        }
    }
}
