import SwiftUI

struct DrinkDetailSheet: View {
    let drink: Drink
    var onAddToCart: (CartItem) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var size: DrinkSize = .large
    @State private var sugar: SugarLevel = .micro
    @State private var ice: IceLevel = .lessIce
    @State private var selectedToppings: Set<Topping> = []
    @State private var note: String = ""
    @State private var quantity: Int = 1
    @State private var isAddedSuccess: Bool = false
    
    var totalPrice: Int {
        let toppingCost = selectedToppings.reduce(0) { $0 + $1.price }
        return (drink.basePrice + size.extraPrice + toppingCost) * quantity
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Top Live Visualizer Header
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [ChingShinTheme.lightGreen, Color.white],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                            
                            VStack(spacing: 12) {
                                BobaCupVisualizer(
                                    drink: drink,
                                    size: size,
                                    sugar: sugar,
                                    ice: ice,
                                    toppings: selectedToppings
                                )
                                .padding(.top, 16)
                                
                                Text(drink.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                Text(drink.englishName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(drink.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Size Selection
                        SectionCard(title: "容量選擇 (Size)") {
                            HStack(spacing: 12) {
                                ForEach(DrinkSize.allCases) { item in
                                    OptionButton(
                                        title: item.rawValue,
                                        subtitle: item.extraPrice > 0 ? "+$\(item.extraPrice)" : "標準",
                                        isSelected: size == item
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            size = item
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Sugar Level Selection
                        SectionCard(title: "甜度選擇 (Sugar)") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(SugarLevel.allCases) { item in
                                    OptionPill(
                                        title: item.shortName,
                                        isSelected: sugar == item
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            sugar = item
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Ice Level Selection
                        SectionCard(title: "冰量選擇 (Ice / Temp)") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(IceLevel.allCases) { item in
                                    OptionPill(
                                        title: item.rawValue,
                                        isSelected: ice == item
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            ice = item
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Toppings Selection
                        SectionCard(title: "加料升級 (Toppings)") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(Topping.allToppings) { topping in
                                    let isSelected = selectedToppings.contains(topping)
                                    HStack {
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(isSelected ? ChingShinTheme.primaryGreen : .gray)
                                        Text(topping.name)
                                            .font(.subheadline.bold())
                                        Spacer()
                                        Text("+$\(topping.price)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(12)
                                    .background(isSelected ? ChingShinTheme.lightGreen : Color(UIColor.tertiarySystemGroupedBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected ? ChingShinTheme.primaryGreen : Color.clear, lineWidth: 1.5)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            if isSelected {
                                                selectedToppings.remove(topping)
                                            } else {
                                                selectedToppings.insert(topping)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Quantity & Notes
                        SectionCard(title: "數量與備註") {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("數量")
                                        .font(.subheadline.bold())
                                    Spacer()
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            if quantity > 1 { quantity -= 1 }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(quantity > 1 ? ChingShinTheme.primaryGreen : .gray)
                                        }
                                        
                                        Text("\(quantity)")
                                            .font(.title3.bold())
                                            .frame(minWidth: 28)
                                        
                                        Button(action: { quantity += 1 }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(ChingShinTheme.primaryGreen)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                TextField("特殊需求（例如：茶濃一點、塑膠袋...）", text: $note)
                                    .textFieldStyle(.plain)
                                    .padding(10)
                                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 80)
                }
                
                // Bottom Fixed Add-To-Cart Bar
                VStack {
                    Spacer()
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("總計金額")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(totalPrice)")
                                .font(.title.bold())
                                .foregroundColor(ChingShinTheme.primaryGreen)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let newItem = CartItem(
                                drink: drink,
                                size: size,
                                sugar: sugar,
                                ice: ice,
                                toppings: selectedToppings,
                                note: note,
                                quantity: quantity
                            )
                            onAddToCart(newItem)
                            withAnimation {
                                isAddedSuccess = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                dismiss()
                            }
                        }) {
                            HStack {
                                Image(systemName: isAddedSuccess ? "checkmark" : "cart.badge.plus")
                                Text(isAddedSuccess ? "已加入購物車！" : "加入購物車")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isAddedSuccess ? Color.green : ChingShinTheme.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: ChingShinTheme.primaryGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("客製化選擇")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MARK: - Subcomponents
struct SectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ChingShinTheme.cardBackground)
        .cornerRadius(18)
        .padding(.horizontal)
    }
}

struct OptionButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? ChingShinTheme.primaryGreen : Color(UIColor.tertiarySystemGroupedBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ChingShinTheme.primaryGreen : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

struct OptionPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? ChingShinTheme.primaryGreen : Color(UIColor.tertiarySystemGroupedBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(10)
        }
    }
}
