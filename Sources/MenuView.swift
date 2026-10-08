import SwiftUI
import Combine

struct MenuView: View {
    @Binding var cartItems: [CartItem]
    @Binding var currentStore: Store
    @Binding var orderMode: OrderMode
    @Binding var deliveryInfo: DeliveryInfo
    @Binding var userProfile: UserProfile
    
    var onSelectDrink: (Drink) -> Void
    var onOpenCart: () -> Void
    var onOpenStoreLocator: () -> Void
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedCategory: DrinkCategory? = .popular
    @State private var searchText: String = ""
    @State private var currentPromoIndex: Int = 0
    @State private var isShowingDeliverySetup: Bool = false
    @State private var showCategoryDrawer: Bool = false
    
    let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var filteredDrinks: [Drink] {
        SampleData.drinks.filter { drink in
            let matchesCategory: Bool
            if let cat = selectedCategory {
                if cat == .popular {
                    matchesCategory = drink.isHotItem || drink.category == .premiumTea || drink.category == .winterMelon || drink.category == .freshMilkLatte
                } else {
                    matchesCategory = (drink.category == cat)
                }
            } else {
                matchesCategory = true
            }
            let matchesSearch = searchText.isEmpty || drink.name.contains(searchText) || drink.description.contains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Bar (Official Brand Logo Badge & Mode Switcher)
                    VStack(spacing: 8) {
                        HStack {
                            // Official Brand Logo (Seamless Transparent PNG)
                            if let logoPath = Bundle.main.path(forResource: "brand_logo", ofType: "png"),
                               let uiImage = UIImage(contentsOfFile: logoPath) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 32)
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.red)
                                    Text("清心福全")
                                        .font(.system(size: 18, weight: .black))
                                        .foregroundColor(AppTheme.primaryGreen)
                                }
                            }
                            
                            Spacer()
                            
                            // Order Mode Switcher (Takeout vs Delivery)
                            HStack(spacing: 0) {
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    withAnimation(.spring(response: 0.3)) {
                                        orderMode = .takeout
                                    }
                                }) {
                                    HStack(spacing: 3) {
                                        Image(systemName: "bag.fill")
                                            .font(.system(size: 10))
                                        Text("外帶自取")
                                            .font(.system(size: 11, weight: .bold))
                                            .lineLimit(1)
                                    }
                                    .foregroundColor(orderMode == .takeout ? .white : AppTheme.textSecondary(isDarkMode))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(orderMode == .takeout ? AppTheme.primaryGreen : Color.clear)
                                    .clipShape(Capsule())
                                }
                                
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    withAnimation(.spring(response: 0.3)) {
                                        orderMode = .delivery
                                    }
                                }) {
                                    HStack(spacing: 3) {
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 10))
                                        Text("外送上門")
                                            .font(.system(size: 11, weight: .bold))
                                            .lineLimit(1)
                                    }
                                    .foregroundColor(orderMode == .delivery ? .white : AppTheme.textSecondary(isDarkMode))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(orderMode == .delivery ? AppTheme.primaryGreen : Color.clear)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(2)
                            .background(AppTheme.inputBg(isDarkMode))
                            .clipShape(Capsule())
                            .fixedSize()
                        }
                        
                        // Row 2: Store & Location Bar
                        if orderMode == .takeout {
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                onOpenStoreLocator()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 4) {
                                            Text(currentStore.shortName)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        }
                                        
                                        Text(currentStore.address)
                                            .font(.system(size: 11))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Circle().fill(Color.green).frame(width: 6, height: 6)
                                        Text("營業中")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(AppTheme.primaryGreen)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppTheme.primaryGreen.opacity(0.12))
                                    .clipShape(Capsule())
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(AppTheme.cardBg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 4, x: 0, y: 2)
                            }
                        } else {
                            // Delivery Mode: Split Bar (Store Selector + Address Picker)
                            HStack(spacing: 8) {
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    onOpenStoreLocator()
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "storefront.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppTheme.primaryGreen)
                                        Text("門市: \(currentStore.shortName)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(AppTheme.cardBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 3, x: 0, y: 1)
                                }
                                
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    isShowingDeliverySetup = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppTheme.primaryGreen)
                                        Text("配送: \(deliveryInfo.address)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(AppTheme.cardBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 3, x: 0, y: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(AppTheme.cardBg(isDarkMode))
                    
                    Divider()
                    
                    // Scrollable Content Body
                    ScrollView {
                        VStack(spacing: 14) {
                            // Promotion Auto Carousel
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
                                .frame(height: 115)
                                .onReceive(timer) { _ in
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentPromoIndex = (currentPromoIndex + 1) % 3
                                    }
                                }
                                
                                HStack(spacing: 6) {
                                    ForEach(0..<3, id: \.self) { idx in
                                        Circle()
                                            .fill(currentPromoIndex == idx ? AppTheme.primaryGreen : Color.gray.opacity(0.3))
                                            .frame(width: currentPromoIndex == idx ? 14 : 6, height: 6)
                                            .animation(.easeInOut(duration: 0.2), value: currentPromoIndex)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                            
                            // Category Selector & Drawer Launcher
                            VStack(alignment: .leading, spacing: 10) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            SoundManager.shared.playTapSound()
                                            showCategoryDrawer = true
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "square.grid.2x2.fill")
                                                    .font(.system(size: 11))
                                                Text("全部分類")
                                                    .font(.system(size: 12, weight: .bold))
                                                Image(systemName: "chevron.down")
                                                    .font(.system(size: 9, weight: .bold))
                                            }
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color(hex: "1F2937"))
                                            .clipShape(Capsule())
                                        }
                                        
                                        CategoryPill(
                                            title: "全部飲品",
                                            isSelected: selectedCategory == nil,
                                            isDark: isDarkMode
                                        ) {
                                            SoundManager.shared.playTapSound()
                                            selectedCategory = nil
                                        }
                                        
                                        ForEach(DrinkCategory.allCases) { cat in
                                            CategoryPill(
                                                title: cat.rawValue,
                                                isSelected: selectedCategory == cat,
                                                isDark: isDarkMode
                                            ) {
                                                SoundManager.shared.playTapSound()
                                                selectedCategory = cat
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            
                            // Category Section Header & Inline Search
                            HStack {
                                Text(selectedCategory?.rawValue ?? "所有飲料品項")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                
                                Text("(\(filteredDrinks.count)款)")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    
                                    TextField("搜尋飲料", text: $searchText)
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    
                                    if !searchText.isEmpty {
                                        Button(action: { searchText = "" }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(AppTheme.inputBg(isDarkMode))
                                .clipShape(Capsule())
                                .frame(width: 135)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                            
                            // Drink Grid
                            if filteredDrinks.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "cup.and.saucer")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                    Text("找不到符合的飲品，請切換分類或重新搜尋")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                                .padding(.vertical, 50)
                            } else {
                                LazyVGrid(columns: columns, spacing: 14) {
                                    ForEach(filteredDrinks) { drink in
                                        DrinkCardView(drink: drink, isDark: isDarkMode) {
                                            SoundManager.shared.playTapSound()
                                            onSelectDrink(drink)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingDeliverySetup) {
                DeliverySetupSheet(deliveryInfo: $deliveryInfo, isPresented: $isShowingDeliverySetup)
            }
            .sheet(isPresented: $showCategoryDrawer) {
                CategoryDrawerSheet(
                    selectedCategory: $selectedCategory,
                    isPresented: $showCategoryDrawer
                )
            }
        }
    }
}

// Category Pill Component
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let isDark: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : AppTheme.textPrimary(isDark))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.primaryGreen : AppTheme.cardBg(isDark))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? AppTheme.primaryGreen : AppTheme.border(isDark), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(isDark ? 0.2 : 0.03), radius: 3, x: 0, y: 1)
        }
    }
}

// Drink Card Component
struct DrinkCardView: View {
    let drink: Drink
    let isDark: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    AppTheme.inputBg(isDark)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Drink3DThumbnailView(style: drink.cupStyle, size: 80)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                    
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary(isDark))
                        .lineLimit(1)
                    
                    Text(drink.description)
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary(isDark))
                        .lineLimit(2)
                        .frame(height: 28, alignment: .top)
                    
                    HStack(alignment: .bottom) {
                        if let pM = drink.priceM {
                            Text("M $\(pM) / L $\(drink.priceL)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.primaryGreen)
                        } else {
                            Text("L $\(drink.priceL)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.primaryGreen)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.primaryGreen)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .background(AppTheme.cardBg(isDark))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(isDark ? 0.3 : 0.05), radius: 6, x: 0, y: 3)
        }
    }
}

// Banner Card Component
struct PromoBannerCard: View {
    let badge: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "008B47"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    Text(title)
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 80)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 36))
                        .foregroundColor(.white.opacity(0.2))
                        .padding(16)
                }
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: gradientColors[0].opacity(0.3), radius: 6, x: 0, y: 3)
    }
}

// Category Drawer Component
struct CategoryDrawerSheet: View {
    @Binding var selectedCategory: DrinkCategory?
    @Binding var isPresented: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            Text("飲料分類選單")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            Spacer()
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                isPresented = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            selectedCategory = nil
                            isPresented = false
                        }) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.primaryGreen)
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "square.grid.3x3.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("全部飲料品項 (不分系列)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                    Text("一次瀏覽清心福全所有完整飲料目錄")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.primaryGreen)
                            }
                            .padding(14)
                            .background(AppTheme.cardBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedCategory == nil ? AppTheme.primaryGreen : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 6, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(DrinkCategory.allCases) { cat in
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    selectedCategory = cat
                                    isPresented = false
                                }) {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(AppTheme.primaryGreen.opacity(0.12))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: cat.iconName)
                                                .font(.system(size: 15))
                                                .foregroundColor(AppTheme.primaryGreen)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(cat.rawValue)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                .lineLimit(1)
                                            Text("查看飲料")
                                                .font(.system(size: 10))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                        }
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(12)
                                    .background(AppTheme.cardBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(selectedCategory == cat ? AppTheme.primaryGreen : AppTheme.border(isDarkMode), lineWidth: selectedCategory == cat ? 2 : 1)
                                    )
                                    .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.03), radius: 4, x: 0, y: 2)
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

// Delivery Setup Sheet Component
struct DeliverySetupSheet: View {
    @Binding var deliveryInfo: DeliveryInfo
    @Binding var isPresented: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var isLocating: Bool = false
    @State private var showLocatedToast: Bool = false
    
    let districts = ["中西區", "東區", "北區", "安平區", "南區", "安南區", "永康區", "仁德區"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            isLocating = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                isLocating = false
                                deliveryInfo.district = "中西區"
                                deliveryInfo.address = "台南市中西區西門路二段100號"
                                showLocatedToast = true
                                SoundManager.shared.playAddToCartSound()
                            }
                        }) {
                            HStack(spacing: 10) {
                                if isLocating {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: "location.circle.fill").font(.system(size: 18))
                                }
                                Text(isLocating ? "定位抓取中..." : "📍 自動定位 (使用目前 GPS 位置)")
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: AppTheme.primaryGreen.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        
                        if showLocatedToast {
                            HStack {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                Text("已自動定位帶入：台南市中西區西門路二段100號")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.cardBg(isDarkMode))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("選擇配送區域")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            
                            HStack {
                                Text("台南市區域")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Picker("區域", selection: $deliveryInfo.district) {
                                    ForEach(districts, id: \.self) { dist in
                                        Text(dist).tag(dist)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.primaryGreen)
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("配送詳細地址與電話")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("街道門牌地址").font(.system(size: 11)).foregroundColor(AppTheme.textSecondary(isDarkMode))
                                TextField("請輸入詳細地址", text: $deliveryInfo.address)
                                    .font(.system(size: 13))
                                    .padding(10)
                                    .background(AppTheme.inputBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("聯絡電話").font(.system(size: 11)).foregroundColor(AppTheme.textSecondary(isDarkMode))
                                TextField("請輸入手機號碼", text: $deliveryInfo.phone)
                                    .font(.system(size: 13))
                                    .padding(10)
                                    .background(AppTheme.inputBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("外送備註 (例如：到達打電話)").font(.system(size: 11)).foregroundColor(AppTheme.textSecondary(isDarkMode))
                                TextField("備註說明", text: $deliveryInfo.notes)
                                    .font(.system(size: 13))
                                    .padding(10)
                                    .background(AppTheme.inputBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("外送運費說明")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            
                            HStack {
                                Text("起送門檻").font(.system(size: 14)).foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Text("NT$ \(deliveryInfo.minDeliveryThreshold)").font(.system(size: 14, weight: .bold)).foregroundColor(AppTheme.primaryGreen)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("基本外送費").font(.system(size: 14)).foregroundColor(AppTheme.textPrimary(isDarkMode))
                                Spacer()
                                Text("NT$ \(deliveryInfo.deliveryFee) (滿$150免運)").font(.system(size: 13)).foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                        }
                        .padding(14)
                        .background(AppTheme.cardBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(16)
                }
            }
            .navigationTitle("設定外送地址與電話")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("確認設定") {
                        SoundManager.shared.playTapSound()
                        isPresented = false
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.primaryGreen)
                }
            }
        }
    }
}
