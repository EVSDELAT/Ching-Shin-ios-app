import SwiftUI

struct MenuView: View {
    @Binding var cartItems: [CartItem]
    @Binding var currentStore: Store
    @Binding var stores: [Store]
    
    @State private var selectedCategory: DrinkCategory = .popular
    @State private var searchText: String = ""
    @State private var selectedDrinkForDetail: Drink? = nil
    @State private var isShowingCartSheet: Bool = false
    @State private var isShowingStorePicker: Bool = false
    
    var filteredDrinks: [Drink] {
        var result = MockData.sampleDrinks
        if selectedCategory != .popular {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.contains(searchText) || $0.englishName.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }
    
    var totalCartCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalCartAmount: Int {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        ZStack {
            ChingShinTheme.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Bar (Store selector + Search)
                VStack(spacing: 12) {
                    HStack {
                        Button(action: { isShowingStorePicker = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(ChingShinTheme.primaryGreen)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 4) {
                                        Text(currentStore.name)
                                            .font(.headline.bold())
                                            .foregroundColor(.primary)
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Text("\(currentStore.address) • 約 \(Int(currentStore.distanceKm * 1000))m")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Status Badge
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("營業中")
                                .font(.caption2.bold())
                                .foregroundColor(ChingShinTheme.darkGreen)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(ChingShinTheme.lightGreen)
                        .cornerRadius(12)
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("搜尋飲料（如：烏龍綠、隱藏版...）", text: $searchText)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(14)
                }
                .padding()
                .background(ChingShinTheme.cardBackground)
                
                // MARK: - Main Scroll Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Banner Slider
                        AnnouncementBannerView()
                            .padding(.top, 12)
                        
                        // Category Horizontal Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(DrinkCategory.allCases) { cat in
                                    CategoryTabPill(
                                        category: cat,
                                        isSelected: selectedCategory == cat
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedCategory = cat
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Drinks Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(filteredDrinks) { drink in
                                DrinkCardView(drink: drink) {
                                    selectedDrinkForDetail = drink
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // MARK: - Floating Cart Bar (Bottom)
            if totalCartCount > 0 {
                VStack {
                    Spacer()
                    FloatingCartBar(
                        count: totalCartCount,
                        amount: totalCartAmount
                    ) {
                        isShowingCartSheet = true
                    }
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sheet(item: $selectedDrinkForDetail) { drink in
            DrinkDetailSheet(drink: drink) { newItem in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    cartItems.append(newItem)
                }
            }
        }
        .sheet(isPresented: $isShowingCartSheet) {
            CartSheet(cartItems: $cartItems, currentStore: currentStore)
        }
        .sheet(isPresented: $isShowingStorePicker) {
            StorePickerSheet(currentStore: $currentStore, stores: stores)
        }
    }
}

// MARK: - Category Pill
struct CategoryTabPill: View {
    let category: DrinkCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.subheadline.bold())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? ChingShinTheme.primaryGreen : ChingShinTheme.cardBackground)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .shadow(color: isSelected ? ChingShinTheme.primaryGreen.opacity(0.3) : Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
}

// MARK: - Drink Card View
struct DrinkCardView: View {
    let drink: Drink
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                // Background Tea Glow
                RoundedRectangle(cornerRadius: 16)
                    .fill(ChingShinTheme.lightGreen.opacity(0.6))
                    .frame(height: 120)
                
                // Drink Emoji / Illustration Preview
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(drink.imageEmoji)
                            .font(.system(size: 64))
                            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                        Spacer()
                    }
                    Spacer()
                }
                
                // Badge
                if drink.isPopular {
                    Text("HOT 熱銷")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ChingShinTheme.accentRed)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(drink.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .frame(height: 28, alignment: .topLeading)
                
                HStack {
                    Text("$\(drink.basePrice)")
                        .font(.title3.bold())
                        .foregroundColor(ChingShinTheme.primaryGreen)
                    
                    Text("起")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: onSelect) {
                        Image(systemName: "plus")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(8)
                            .background(ChingShinTheme.primaryGreen)
                            .clipShape(Circle())
                            .shadow(color: ChingShinTheme.primaryGreen.opacity(0.4), radius: 4, y: 2)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(10)
        .background(ChingShinTheme.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onSelect()
        }
    }
}

// MARK: - Announcement Banner
struct AnnouncementBannerView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [ChingShinTheme.primaryGreen, ChingShinTheme.darkGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: ChingShinTheme.primaryGreen.opacity(0.3), radius: 8, y: 4)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("PROMO 招牌特調")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(ChingShinTheme.goldYellow)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        
                        Text("清心經典重現")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Text("隱藏版 珍珠椰果奶綠")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text("高山綠茶與濃香奶味，雙料爆棚極致口感！")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Spacer()
                
                Text("🧋")
                    .font(.system(size: 50))
            }
            .padding(16)
        }
        .padding(.horizontal)
    }
}

// MARK: - Floating Cart Bar
struct FloatingCartBar: View {
    let count: Int
    let amount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .fill(ChingShinTheme.goldYellow)
                        .frame(width: 32, height: 32)
                    Text("\(count)")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("已選購 \(count) 杯飲料")
                        .font(.subheadline.bold())
                    Text("前往確認菜單清單")
                        .font(.caption2)
                        .opacity(0.9)
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Text("$\(amount)")
                    .font(.title3.bold())
                    .foregroundColor(ChingShinTheme.goldYellow)
                
                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(ChingShinTheme.primaryGreen)
            .cornerRadius(24)
            .shadow(color: ChingShinTheme.primaryGreen.opacity(0.4), radius: 12, x: 0, y: 6)
            .padding(.horizontal)
        }
    }
}

// MARK: - Store Picker Modal Sheet
struct StorePickerSheet: View {
    @Binding var currentStore: Store
    let stores: [Store]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(stores) { store in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.name)
                            .font(.headline)
                        Text(store.address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("營業時間：\(store.businessHours) • 距離 \(String(format: "%.1f", store.distanceKm)) km")
                            .font(.caption2)
                            .foregroundColor(ChingShinTheme.primaryGreen)
                    }
                    Spacer()
                    if currentStore.id == store.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(ChingShinTheme.primaryGreen)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    currentStore = store
                    dismiss()
                }
            }
            .navigationTitle("選擇門市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
