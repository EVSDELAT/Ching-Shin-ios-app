import SwiftUI

struct MenuView: View {
    @Binding var cartItems: [CartItem]
    @Binding var currentStore: Store
    @Binding var orderMode: OrderMode
    @Binding var deliveryInfo: DeliveryInfo
    @Binding var userProfile: UserProfile
    
    var onSelectDrink: (Drink) -> Void
    var onOpenCart: () -> Void
    var onOpenStoreLocator: () -> Void
    
    @State private var selectedCategory: DrinkCategory = .popular
    @State private var searchText: String = ""
    @State private var currentPromoIndex: Int = 0
    @State private var isShowingDeliverySetup: Bool = false
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var filteredDrinks: [Drink] {
        SampleData.drinks.filter { drink in
            let matchesCategory = (selectedCategory == .popular) || (drink.category == selectedCategory)
            let matchesSearch = searchText.isEmpty || drink.name.contains(searchText) || drink.description.contains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mode Segmented Picker & Header
                VStack(spacing: 8) {
                    // Segmented Mode Switcher ([外帶自取] vs [外送上門])
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                orderMode = .takeout
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "bag.fill")
                                Text("外帶自取")
                            }
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(orderMode == .takeout ? .white : Color(hex: "008B47"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(orderMode == .takeout ? Color(hex: "008B47") : Color.clear)
                            .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                orderMode = .delivery
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "bicycle")
                                Text("外送上門")
                            }
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(orderMode == .delivery ? .white : Color(hex: "008B47"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(orderMode == .delivery ? Color(hex: "008B47") : Color.clear)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(3)
                    .background(Color.gray.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Location / Store Header Info
                    if orderMode == .takeout {
                        Button(action: onOpenStoreLocator) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "008B47"))
                                        .frame(width: 34, height: 34)
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text(currentStore.name)
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.primary)
                                        Image(systemName: "chevron.down")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("🟢 營業中")
                                            .font(.caption2)
                                            .bold()
                                            .foregroundColor(.green)
                                    }
                                    Text("\(currentStore.address) ‧ 約 \(currentStore.distance)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button(action: { isShowingDeliverySetup = true }) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 34, height: 34)
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text("外送至: \(deliveryInfo.address)")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                        Image(systemName: "pencil")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    Text("滿 $150 免外送費 ‧ 備註: \(deliveryInfo.notes)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(Color.white)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜尋清心飲料（如：紅柚綠、烏龍綠、隱藏版...）", text: $searchText)
                        .font(.subheadline)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Real Ching Shin Promotions Banner Carousel
                        TabView(selection: $currentPromoIndex) {
                            ForEach(0..<SampleData.promos.count, id: \.self) { idx in
                                let promo = SampleData.promos[idx]
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                colors: promo.bgColors,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(spacing: 6) {
                                                Text(promo.tag)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 3)
                                                    .background(Color.yellow)
                                                    .foregroundColor(.black)
                                                    .clipShape(Capsule())
                                                
                                                Text("清心福全 2026 最新企劃")
                                                    .font(.caption2)
                                                    .foregroundColor(.white.opacity(0.9))
                                            }
                                            
                                            Text(promo.title)
                                                .font(.headline)
                                                .bold()
                                                .foregroundColor(.white)
                                            
                                            Text(promo.subtitle)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.85))
                                                .lineLimit(2)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: promo.iconName)
                                            .font(.system(size: 32))
                                            .foregroundColor(.yellow)
                                    }
                                    .padding(16)
                                }
                                .padding(.horizontal, 16)
                                .tag(idx)
                            }
                        }
                        .frame(height: 120)
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        
                        // Category Pills Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(DrinkCategory.allCases) { category in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedCategory = category
                                        }
                                    }) {
                                        HStack(spacing: 5) {
                                            Image(systemName: category.iconName)
                                                .font(.caption)
                                            Text(category.rawValue)
                                                .font(.subheadline)
                                                .fontWeight(selectedCategory == category ? .bold : .semibold)
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color(hex: "008B47") : Color.gray.opacity(0.12))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .clipShape(Capsule())
                                        .shadow(color: selectedCategory == category ? Color(hex: "008B47").opacity(0.3) : Color.clear, radius: 4, y: 2)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Category Drinks Count Header
                        HStack {
                            Text("\(selectedCategory.rawValue) (\(filteredDrinks.count)款)")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        // 2-Column Grid Layout
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(filteredDrinks) { drink in
                                DrinkGridCard(drink: drink) {
                                    onSelectDrink(drink)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 90)
                    }
                    .padding(.top, 4)
                }
            }
            .navigationBarHidden(true)
            .background(Color(hex: "F8F9FA"))
            .sheet(isPresented: $isShowingDeliverySetup) {
                DeliverySetupView(deliveryInfo: $deliveryInfo, userProfile: userProfile)
            }
        }
    }
}

// MARK: - Delivery Setup View (外送地址與定位彈窗)
struct DeliverySetupView: View {
    @Binding var deliveryInfo: DeliveryInfo
    let userProfile: UserProfile
    @Environment(\.dismiss) private var dismiss
    
    let tainanDistricts = ["中西區", "東區", "南區", "北區", "安平區", "安南區", "永康區", "新市區", "善化區"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("GPS 定位與地址")) {
                    Button(action: {
                        withAnimation {
                            deliveryInfo.district = "中西區"
                            deliveryInfo.address = "台南市中西區西門路二段100號"
                        }
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(hex: "008B47"))
                            Text("📍 使用目前位置 GPS 定位 (台南市)")
                                .bold()
                                .foregroundColor(Color(hex: "008B47"))
                        }
                    }
                    
                    Picker("台南市行政區", selection: $deliveryInfo.district) {
                        ForEach(tainanDistricts, id: \.self) { dist in
                            Text(dist).tag(dist)
                        }
                    }
                    
                    TextField("詳細外送地址（門牌/樓層）", text: $deliveryInfo.address)
                }
                
                Section(header: Text("外送聯絡電話與備註")) {
                    TextField("聯絡電話", text: $deliveryInfo.phone)
                        .keyboardType(.phonePad)
                    
                    Picker("外送備註需求", selection: $deliveryInfo.notes) {
                        Text("到達請打電話").tag("到達請打電話")
                        Text("放置管理室代收").tag("放置管理室代收")
                        Text("送到門口/樓層").tag("送到門口/樓層")
                        Text("無特殊需求").tag("無特殊需求")
                    }
                }
                
                Section(header: Text("外送費計算說明")) {
                    HStack {
                        Text("外送起送門檻")
                        Spacer()
                        Text("滿 $150 元起送")
                    }
                    HStack {
                        Text("外送服務費")
                        Spacer()
                        Text("未滿 $150 滿額免運 (收 $30)")
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("設定外送地址與定位")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                        .bold()
                        .foregroundColor(Color(hex: "008B47"))
                }
            }
        }
    }
}

// MARK: - 2-Column Drink Grid Card
struct DrinkGridCard: View {
    let drink: Drink
    let onTap: () -> Void
    
    var priceText: String {
        if let pM = drink.priceM {
            return "M$ \(pM) / L$ \(drink.priceL)"
        } else {
            return "L$ \(drink.priceL)"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "F3F4F6"))
                        .frame(height: 120)
                    
                    Drink3DThumbnailView(style: drink.cupStyle, size: 85)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    if drink.isHotItem {
                        Text("HOT 熱銷")
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(drink.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .frame(height: 28, alignment: .topLeading)
                    
                    HStack {
                        Text(priceText)
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color(hex: "008B47"))
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "008B47"))
                                .frame(width: 26, height: 26)
                            Image(systemName: "plus")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
