import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("themeMode") private var themeMode: String = "light"
    
    @State private var cartItems: [CartItem] = []
    @State private var selectedDrink: Drink? = nil
    @State private var selectedStore: Store = SampleData.sampleStores[0]
    @State private var orderMode: OrderMode = .takeout
    @State private var deliveryInfo: DeliveryInfo = DeliveryInfo()
    @State private var userProfile: UserProfile = UserProfile()
    
    @State private var isShowingCart: Bool = false
    @State private var isShowingStoreLocator: Bool = false
    @State private var isShowingOrderProgress: Bool = false
    @State private var cartBounceScale: CGFloat = 1.0
    @State private var selectedTab: Int = 0
    
    @State private var completedOrders: [CompletedOrder] = [
        CompletedOrder(
            orderNo: "#CS-883920",
            storeName: "清心福全 台南總店(西門二店)",
            orderModeName: "外帶自取",
            items: [
                CartItem(drink: SampleData.drinks[0], size: .large, sugar: .less8, ice: .lessIce, toppings: [.boba], quantity: 1),
                CartItem(drink: SampleData.drinks[1], size: .large, sugar: .zero, ice: .noIce, toppings: [], quantity: 1)
            ],
            totalPrice: 110,
            dateString: "2026/10/08 11:30",
            status: "已完成"
        )
    ]
    
    @State private var pendingCheckoutItems: [CartItem] = []
    
    var totalCartItemsCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalCartPrice: Int {
        let subtotal = cartItems.reduce(0) { $0 + $1.totalPrice }
        let discount = subtotal >= 200 ? 20 : 0
        let fee = orderMode == .delivery ? deliveryInfo.calculateDeliveryFee(subtotal: subtotal) : 0
        return max(0, subtotal - discount + fee)
    }
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashVideoView {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(999)
            } else {
                ZStack(alignment: .bottom) {
                    // Main Tab View
                    TabView(selection: $selectedTab) {
                        MenuView(
                            cartItems: $cartItems,
                            currentStore: $selectedStore,
                            orderMode: $orderMode,
                            deliveryInfo: $deliveryInfo,
                            userProfile: $userProfile,
                            onSelectDrink: { drink in
                                selectedDrink = drink
                            },
                            onOpenCart: {
                                isShowingCart = true
                            },
                            onOpenStoreLocator: {
                                selectedTab = 1 // Switch to Store Tab
                            }
                        )
                        .tabItem {
                            Label("菜單點餐", systemImage: "cup.and.saucer.fill")
                        }
                        .tag(0)
                        
                        StoreLocatorMainView(selectedStore: $selectedStore, selectedTab: $selectedTab)
                        .tabItem {
                            Label("門市據點", systemImage: "mappin.and.ellipse")
                        }
                        .tag(1)
                        
                        MemberCardView(userProfile: $userProfile)
                        .tabItem {
                            Label("會員專區", systemImage: "person.crop.square.fill")
                        }
                        .tag(2)
                        
                        OrderHistoryView(orders: completedOrders, onReorder: { items in
                            cartItems.append(contentsOf: items)
                            selectedTab = 0
                            isShowingCart = true
                        })
                        .tabItem {
                            Label("歷史訂單", systemImage: "clock.fill")
                        }
                        .tag(3)
                        
                        SettingsView()
                        .tabItem {
                            Label("系統設定", systemImage: "gearshape.fill")
                        }
                        .tag(4)
                    }
                    .accentColor(Color(hex: "008B47"))
                    
                    // Floating Cart Action Bar
                    if !cartItems.isEmpty && selectedTab == 0 {
                        VStack {
                            Button(action: {
                                SoundManager.shared.playTapSound()
                                isShowingCart = true
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "cart.fill")
                                            .font(.title3)
                                            .foregroundColor(Color(hex: "008B47"))
                                        
                                        ZStack {
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 20, height: 20)
                                            Text("\(totalCartItemsCount)")
                                                .font(.caption2)
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        .offset(x: 14, y: -14)
                                        .scaleEffect(cartBounceScale)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("已選點餐 (\(orderMode.rawValue) ‧ \(totalCartItemsCount)杯)")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.white)
                                        Text("\(orderMode == .takeout ? selectedStore.name : deliveryInfo.address)")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.85))
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("NT$ \(totalCartPrice)")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 60)
                    }
                }
            }
        }
        .preferredColorScheme(themeMode == "light" ? .light : (themeMode == "dark" ? .dark : nil))
        .sheet(item: $selectedDrink) { drink in
            DrinkDetailView(drink: drink) { newItem in
                cartItems.append(newItem)
                triggerCartBounce()
            }
        }
        .sheet(isPresented: $isShowingCart) {
            CartView(
                cartItems: $cartItems,
                orderMode: $orderMode,
                selectedStore: $selectedStore,
                deliveryInfo: $deliveryInfo,
                onCheckout: {
                    pendingCheckoutItems = cartItems
                    isShowingCart = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShowingOrderProgress = true
                    }
                },
                onOpenStoreLocator: {
                    isShowingCart = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isShowingStoreLocator = true
                    }
                }
            )
        }
        .fullScreenCover(isPresented: $isShowingOrderProgress) {
            OrderProgressView(
                orderItems: pendingCheckoutItems,
                storeName: selectedStore.name,
                orderModeName: orderMode.rawValue,
                onComplete: { completedOrder in
                    SoundManager.shared.playOrderSuccessSound()
                    completedOrders.insert(completedOrder, at: 0)
                    cartItems.removeAll()
                    isShowingOrderProgress = false
                    selectedTab = 3 // Switch to History Tab
                }
            )
        }
    }
    
    private func triggerCartBounce() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
            cartBounceScale = 1.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring()) {
                cartBounceScale = 1.0
            }
        }
    }
}

// MARK: - Store Locator Main View with Map Button (All Taiwan Stores)
struct StoreLocatorMainView: View {
    @Binding var selectedStore: Store
    @Binding var selectedTab: Int
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var mapStoreTarget: Store? = nil
    @State private var searchStoreText: String = ""
    @State private var selectedCity: String = "全部"
    
    var filteredStores: [Store] {
        TaiwanStoresData.allStores.filter { store in
            let matchCity = (selectedCity == "全部") || store.city == selectedCity || store.address.hasPrefix(selectedCity)
            let matchSearch = searchStoreText.isEmpty ||
                              store.name.localizedCaseInsensitiveContains(searchStoreText) ||
                              store.address.localizedCaseInsensitiveContains(searchStoreText) ||
                              store.district.localizedCaseInsensitiveContains(searchStoreText)
            return matchCity && matchSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        TextField("搜尋全台門市名稱、區、路名...", text: $searchStoreText)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textPrimary(isDarkMode))
                        if !searchStoreText.isEmpty {
                            Button(action: { searchStoreText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                        }
                    }
                    .padding(12)
                    .background(AppTheme.inputBg(isDarkMode))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // City Filter Horizontal Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(TaiwanStoresData.cities, id: \.self) { city in
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    selectedCity = city
                                }) {
                                    Text(city)
                                        .font(.system(size: 13, weight: selectedCity == city ? .bold : .medium))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(selectedCity == city ? AppTheme.primaryGreen : AppTheme.cardBg(isDarkMode))
                                        .foregroundColor(selectedCity == city ? .white : AppTheme.textPrimary(isDarkMode))
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(selectedCity == city ? Color.clear : AppTheme.border(isDarkMode), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    
                    // Results count
                    HStack {
                        Text("全台門市共 \(TaiwanStoresData.allStores.count) 家 ‧ 目前篩選出 \(filteredStores.count) 家")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)
                    
                    // Stores List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredStores) { store in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(store.id == selectedStore.id ? AppTheme.primaryGreen : AppTheme.inputBg(isDarkMode))
                                                .frame(width: 42, height: 42)
                                            Image(systemName: "mappin.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(store.id == selectedStore.id ? .white : AppTheme.primaryGreen)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(store.name)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                Spacer()
                                                if store.id == selectedStore.id {
                                                    Text("目前選擇")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 3)
                                                        .background(AppTheme.primaryGreen)
                                                        .foregroundColor(.white)
                                                        .clipShape(Capsule())
                                                }
                                            }
                                            
                                            Text(store.address)
                                                .font(.system(size: 12))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                            
                                            HStack(spacing: 10) {
                                                HStack(spacing: 4) {
                                                    Circle().fill(Color.green).frame(width: 6, height: 6)
                                                    Text("營業中 (\(store.operatingHours))")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.green)
                                                }
                                                if !store.phone.isEmpty {
                                                    Text("電話: \(store.phone)")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                                }
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                        .background(AppTheme.border(isDarkMode))
                                    
                                    // Action Buttons Row (Map Navigation + Store Select)
                                    HStack(spacing: 10) {
                                        Button(action: {
                                            SoundManager.shared.playTapSound()
                                            mapStoreTarget = store
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "map.fill")
                                                    .font(.caption2)
                                                Text("查看地圖導航")
                                                    .font(.system(size: 12, weight: .bold))
                                            }
                                            .foregroundColor(AppTheme.primaryGreen)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(AppTheme.primaryGreen.opacity(0.12))
                                            .clipShape(Capsule())
                                        }
                                        
                                        Spacer()
                                        
                                        if store.id != selectedStore.id {
                                            Button("選擇此門市") {
                                                SoundManager.shared.playTapSound()
                                                selectedStore = store
                                                selectedTab = 0
                                            }
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 6)
                                            .background(AppTheme.primaryGreen)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                        }
                                    }
                                }
                                .padding(14)
                                .background(AppTheme.cardBg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 90)
                    }
                }
            }
            .navigationTitle("門市據點")
            .sheet(item: $mapStoreTarget) { store in
                StoreMapSheet(store: store)
            }
        }
    }
}

