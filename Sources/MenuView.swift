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
    @State private var showCategoryDrawer: Bool = false
    
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
                // Header Area
                VStack(spacing: 10) {
                    // Row 1: App Title & Mode Segmented Controller
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "drop.fill")
                                .foregroundColor(Color(hex: "008B47"))
                            Text("清心福全")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(Color(hex: "008B47"))
                        }
                        
                        Spacer()
                        
                        // Pick up vs Delivery Segmented Button
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    orderMode = .takeout
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "bag.fill")
                                        .font(.system(size: 11))
                                    Text("外帶自取")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(orderMode == .takeout ? .white : Color(hex: "4B5563"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(orderMode == .takeout ? Color(hex: "008B47") : Color.clear)
                                .clipShape(Capsule())
                            }
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    orderMode = .delivery
                                    isShowingDeliverySetup = true
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "bicycle")
                                        .font(.system(size: 11))
                                    Text("外送上門")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(orderMode == .delivery ? .white : Color(hex: "4B5563"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(orderMode == .delivery ? Color(hex: "008B47") : Color.clear)
                                .clipShape(Capsule())
                            }
                        }
                        .padding(3)
                        .background(Color(hex: "E5E7EB"))
                        .clipShape(Capsule())
                    }
                    
                    // Row 2: Selected Store & Address Bar
                    Button(action: {
                        if orderMode == .takeout {
                            onOpenStoreLocator()
                        } else {
                            isShowingDeliverySetup = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: orderMode == .takeout ? "mappin.circle.fill" : "location.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "008B47"))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(orderMode == .takeout ? currentStore.name : "外送門市: \(currentStore.name)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(hex: "1F2937"))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "6B7280"))
                                }
                                
                                Text(orderMode == .takeout ? currentStore.address : "配送至: \(deliveryInfo.address)")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "6B7280"))
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                                Text("營業中")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(hex: "008B47"))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "008B47").opacity(0.1))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: "F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(Color.white)
                
                Divider()
                
                // Main Scrollable Area
                ScrollView {
                    VStack(spacing: 16) {
                        // Search Bar
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "9CA3AF"))
                                .font(.system(size: 15))
                            
                            TextField("搜尋飲料（如：紅柚綠、烏龍綠、隱藏版...）", text: $searchText)
                                .font(.system(size: 14))
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(hex: "9CA3AF"))
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        
                        // Promotion Carousel
                        if searchText.isEmpty {
                            VStack(spacing: 8) {
                                TabView(selection: $currentPromoIndex) {
                                    PromoBannerCard(
                                        badge: "聯名強打",
                                        title: "清心福全 × 貓貓蟲咖波",
                                        subtitle: "奇幻森林探險隊！9款名紙杯與咖波變色杯現場熱烈加購中",
                                        gradientColors: [Color(hex: "008B47"), Color(hex: "005C2B")]
                                    )
                                    .tag(0)
                                    
                                    PromoBannerCard(
                                        badge: "新品熱銷",
                                        title: "RedBull 能量特調系列",
                                        subtitle: "巨峰葡萄能量果醋／RedBull能量藍蜜綠茶 勁爽登場",
                                        gradientColors: [Color(hex: "DC2626"), Color(hex: "991B1B")]
                                    )
                                    .tag(1)
                                    
                                    PromoBannerCard(
                                        badge: "限時優惠",
                                        title: "高山烏龍綠茶 同品項折$5",
                                        subtitle: "採用嚴選特級高山烏龍茶葉，清香甘醇，回甘無窮",
                                        gradientColors: [Color(hex: "059669"), Color(hex: "047857")]
                                    )
                                    .tag(2)
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                .frame(height: 120)
                                
                                // Indicators
                                HStack(spacing: 6) {
                                    ForEach(0..<3, id: \.self) { idx in
                                        Circle()
                                            .fill(currentPromoIndex == idx ? Color(hex: "008B47") : Color(hex: "D1D5DB"))
                                            .frame(width: currentPromoIndex == idx ? 14 : 6, height: 6)
                                            .animation(.easeInOut(duration: 0.2), value: currentPromoIndex)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Category Selector Bar & "全部分類 ☰" Button
                        VStack(alignment: .leading, spacing: 10) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    // "全部分類" Button (Mandatory User Requirement #3)
                                    Button(action: {
                                        showCategoryDrawer = true
                                    }) {
                                        HStack(spacing: 5) {
                                            Image(systemName: "square.grid.2x2.fill")
                                                .font(.system(size: 12))
                                            Text("全部分類")
                                                .font(.system(size: 13, weight: .bold))
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 9, weight: .bold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(Color(hex: "1F2937"))
                                        .clipShape(Capsule())
                                        .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
                                    }
                                    
                                    Divider()
                                        .frame(height: 18)
                                    
                                    ForEach(DrinkCategory.allCases) { cat in
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedCategory = cat
                                            }
                                        }) {
                                            Text(cat.rawValue)
                                                .font(.system(size: 13, weight: selectedCategory == cat ? .bold : .medium))
                                                .foregroundColor(selectedCategory == cat ? .white : Color(hex: "374151"))
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(selectedCategory == cat ? Color(hex: "008B47") : Color.white)
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule()
                                                        .stroke(selectedCategory == cat ? Color(hex: "008B47") : Color(hex: "E5E7EB"), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            // Category Section Header
                            HStack {
                                Text("\(selectedCategory.rawValue)")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(hex: "1F2937"))
                                
                                Text("(\(filteredDrinks.count)款)")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "6B7280"))
                                
                                Spacer()
                                
                                Button(action: {
                                    showCategoryDrawer = true
                                }) {
                                    HStack(spacing: 4) {
                                        Text("全部分類目錄")
                                            .font(.system(size: 12, weight: .bold))
                                        Image(systemName: "line.3.horizontal.decrease.circle")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(Color(hex: "008B47"))
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Drinks Grid
                        if filteredDrinks.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "mug.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(Color(hex: "D1D5DB"))
                                Text("沒有找到相符的飲料品項")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(filteredDrinks) { drink in
                                    DrinkGridCard(drink: drink) {
                                        onSelectDrink(drink)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 130) // Sufficient bottom space so tab bar does not obscure content
                }
                .background(Color(hex: "F9FAFB"))
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingDeliverySetup) {
                DeliverySetupSheet(deliveryInfo: $deliveryInfo, isPresented: $isShowingDeliverySetup)
            }
            .sheet(isPresented: $showCategoryDrawer) {
                AllCategoriesDrawerSheetView(
                    selectedCategory: $selectedCategory,
                    isPresented: $showCategoryDrawer
                )
            }
        }
    }
}

// Promo Banner Card
struct PromoBannerCard: View {
    let badge: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(gradientColors.first ?? Color(hex: "008B47"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: "FEF08A"))
                        .clipShape(Capsule())
                    
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "FEF08A"))
            }
            .padding(14)
        }
    }
}

// Grid Item Card for Drink
struct DrinkGridCard: View {
    let drink: Drink
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "F3F4F6"), Color(hex: "E5E7EB")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 115)
                    
                    Drink3DThumbnailView(style: drink.cupStyle)
                        .frame(width: 80, height: 95)
                        .padding(.top, 8)
                    
                    if drink.isHotItem {
                        Text("HOT 熱銷")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(drink.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .lineLimit(1)
                    
                    Text(drink.description)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "6B7280"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 26, alignment: .topLeading)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            if let pM = drink.priceM {
                                Text("M $\(pM) / L $\(drink.priceL)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "008B47"))
                            } else {
                                Text("L $\(drink.priceL)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "008B47"))
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "008B47"))
                                .frame(width: 24, height: 24)
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(10)
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
}

// Drawer Sheet View for All Drink Categories
struct AllCategoriesDrawerSheetView: View {
    @Binding var selectedCategory: DrinkCategory
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F8F9FA").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("全部分類菜單目錄")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "1F2937"))
                                Text("點擊類別快速切換飲料項目 (共 13 大系列)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            Spacer()
                            
                            Button(action: { isPresented = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "9CA3AF"))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(DrinkCategory.allCases) { cat in
                                Button(action: {
                                    selectedCategory = cat
                                    isPresented = false
                                }) {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "008B47").opacity(0.12))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: cat.iconName)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color(hex: "008B47"))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(cat.rawValue)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color(hex: "1F2937"))
                                                .lineLimit(1)
                                            Text("查看飲料")
                                                .font(.system(size: 10))
                                                .foregroundColor(Color(hex: "6B7280"))
                                        }
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(selectedCategory == cat ? Color(hex: "008B47") : Color(hex: "E5E7EB"), lineWidth: selectedCategory == cat ? 2 : 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Delivery Setup Sheet
struct DeliverySetupSheet: View {
    @Binding var deliveryInfo: DeliveryInfo
    @Binding var isPresented: Bool
    
    let districts = ["中西區", "東區", "北區", "安平區", "南區", "安南區", "永康區", "仁德區"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("選擇配送區域")) {
                    Picker("台南市區域", selection: $deliveryInfo.district) {
                        ForEach(districts, id: \.self) { dist in
                            Text(dist).tag(dist)
                        }
                    }
                }
                
                Section(header: Text("配送詳細地址")) {
                    TextField("請輸入街道門牌（如：西門路二段100號 5樓）", text: $deliveryInfo.address)
                    TextField("聯絡電話", text: $deliveryInfo.phone)
                    TextField("外送備註（如：放管理室/到達請撥電話）", text: $deliveryInfo.notes)
                }
                
                Section(header: Text("外送運費說明")) {
                    HStack {
                        Text("起送門檻")
                        Spacer()
                        Text("NT$ \(deliveryInfo.minDeliveryThreshold)")
                            .bold()
                            .foregroundColor(Color(hex: "008B47"))
                    }
                    HStack {
                        Text("基本外送費")
                        Spacer()
                        Text("NT$ \(deliveryInfo.deliveryFee) (滿$150免外送費)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("設定外送地址與電話")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("確認設定") {
                isPresented = false
            })
        }
    }
}
