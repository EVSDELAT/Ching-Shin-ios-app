import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("themeMode") private var themeMode: String = "light"
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var cartItems: [CartItem] = []
    @State private var selectedDrink: Drink? = nil
    @State private var selectedStore: Store = SampleData.sampleStores[0]
    @State private var orderMode: OrderMode = .takeout
    @State private var deliveryInfo: DeliveryInfo = DeliveryInfo()
    @State private var userProfile: UserProfile = {
        var profile = UserProfile()
        if let savedBarcode = UserDefaults.standard.string(forKey: "userCarrierBarcode"), !savedBarcode.isEmpty {
            profile.carrierBarcode = savedBarcode
        }
        return profile
    }()
    
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
        .onAppear {
            syncDarkMode()
        }
        .onChange(of: themeMode) { _ in
            syncDarkMode()
        }
        .onChange(of: colorScheme) { _ in
            syncDarkMode()
        }
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
    
    private func syncDarkMode() {
        if themeMode == "dark" {
            isDarkMode = true
        } else if themeMode == "light" {
            isDarkMode = false
        } else {
            isDarkMode = (colorScheme == .dark)
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

// MARK: - Store Locator Main View with Dropdowns & GPS (All Taiwan Stores)
struct StoreLocatorMainView: View {
    @Binding var selectedStore: Store
    @Binding var selectedTab: Int
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedCity: String = "全部"
    @State private var selectedDistrict: String = "全部鄉鎮"
    @State private var searchStoreText: String = ""
    @State private var isLocating: Bool = false
    @State private var locationNotice: String? = nil
    @State private var mapStoreTarget: Store? = nil
    
    var filteredStores: [Store] {
        TaiwanStoresData.allStores.filter { store in
            let matchCity = (selectedCity == "全部") || store.city == selectedCity || store.address.hasPrefix(selectedCity)
            let matchDistrict = (selectedDistrict == "全部鄉鎮") || store.district == selectedDistrict || store.address.contains(selectedDistrict)
            let matchSearch = searchStoreText.isEmpty ||
                              store.name.localizedCaseInsensitiveContains(searchStoreText) ||
                              store.address.localizedCaseInsensitiveContains(searchStoreText) ||
                              store.district.localizedCaseInsensitiveContains(searchStoreText)
            return matchCity && matchDistrict && matchSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg(isDarkMode).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Filtering Controls
                    VStack(spacing: 10) {
                        // Dropdowns Row: 1. 縣市  2. 鄉鎮市區
                        HStack(spacing: 10) {
                            // Dropdown 1: 縣市
                            Menu {
                                ForEach(TaiwanStoresData.cities, id: \.self) { city in
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        selectedCity = city
                                        selectedDistrict = "全部鄉鎮"
                                        locationNotice = nil
                                    }) {
                                        HStack {
                                            Text(city)
                                            if selectedCity == city {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "building.2.crop.circle")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Text(selectedCity == "全部" ? "1. 選擇縣市" : selectedCity)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(AppTheme.cardBg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border(isDarkMode), lineWidth: 1)
                                )
                            }
                            
                            // Dropdown 2: 鄉鎮市區
                            Menu {
                                ForEach(TaiwanStoresData.districts(for: selectedCity), id: \.self) { dist in
                                    Button(action: {
                                        SoundManager.shared.playTapSound()
                                        selectedDistrict = dist
                                        locationNotice = nil
                                    }) {
                                        HStack {
                                            Text(dist)
                                            if selectedDistrict == dist {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppTheme.primaryGreen)
                                    Text(selectedDistrict == "全部鄉鎮" ? "2. 選擇鄉鎮" : selectedDistrict)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(AppTheme.cardBg(isDarkMode))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border(isDarkMode), lineWidth: 1)
                                )
                            }
                        }
                        
                        // GPS Auto Location Button
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            isLocating = true
                            LocationManager.shared.fetchCurrentLocation { district, address in
                                isLocating = false
                                for city in TaiwanStoresData.cities where city != "全部" {
                                    if address.contains(city) {
                                        selectedCity = city
                                        break
                                    }
                                }
                                let districtList = TaiwanStoresData.districts(for: selectedCity)
                                if districtList.contains(district) {
                                    selectedDistrict = district
                                }
                                locationNotice = "已定位至：\(selectedCity) \(selectedDistrict)"
                                SoundManager.shared.playAddToCartSound()
                            }
                        }) {
                            HStack(spacing: 8) {
                                if isLocating {
                                    ProgressView().tint(.white).scaleEffect(0.8)
                                } else {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 13))
                                }
                                Text(isLocating ? "抓取手機 GPS 定位中..." : "📍 自動定位 (依目前 GPS 篩選最近門市)")
                                    .font(.system(size: 13, weight: .bold))
                                Spacer()
                                Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "008B47"), Color(hex: "006834")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: AppTheme.primaryGreen.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            TextField("搜尋全台門市名稱、街道...", text: $searchStoreText)
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.textPrimary(isDarkMode))
                            if !searchStoreText.isEmpty {
                                Button(action: { searchStoreText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                }
                            }
                        }
                        .padding(10)
                        .background(AppTheme.inputBg(isDarkMode))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // Results Count & Notice
                        HStack {
                            if let notice = locationNotice {
                                Text(notice)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(AppTheme.primaryGreen)
                            } else {
                                Text("全台門市共 \(TaiwanStoresData.allStores.count) 家 ‧ 目前篩選出 \(filteredStores.count) 家")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            Spacer()
                        }
                    }
                    .padding(14)
                    
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
                                                    .lineLimit(1)
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
                                                .lineLimit(1)
                                            
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
