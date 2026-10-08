import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
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
                        
                        StoreLocatorMainView(selectedStore: $selectedStore)
                        .tabItem {
                            Label("門市據點", systemImage: "mappin.and.ellipse")
                        }
                        .tag(1)
                        
                        MemberCardView(userProfile: $userProfile)
                        .tabItem {
                            Label("會員專區", systemImage: "person.crop.square.fill")
                        }
                        .tag(2)
                        
                        OrderHistoryView(orders: completedOrders)
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
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(item: $selectedDrink) { drink in
            DrinkDetailView(drink: drink) { newItem in
                cartItems.append(newItem)
                triggerCartBounce()
            }
        }
        .sheet(isPresented: $isShowingCart) {
            CartView(
                cartItems: $cartItems,
                orderMode: orderMode,
                deliveryInfo: deliveryInfo,
                onCheckout: {
                    pendingCheckoutItems = cartItems
                    isShowingCart = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isShowingOrderProgress = true
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

// MARK: - Store Locator Main View with Map Button (Requirement #4)
struct StoreLocatorMainView: View {
    @Binding var selectedStore: Store
    @State private var mapStoreTarget: Store? = nil
    
    var body: some View {
        NavigationStack {
            List(SampleData.sampleStores) { store in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(store.id == selectedStore.id ? Color(hex: "008B47") : Color.gray.opacity(0.12))
                                .frame(width: 42, height: 42)
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(store.id == selectedStore.id ? .white : Color(hex: "008B47"))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(store.name)
                                    .font(.headline)
                                Spacer()
                                if store.id == selectedStore.id {
                                    Text("預設門市")
                                        .font(.system(size: 9, weight: .bold))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(hex: "008B47"))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                            
                            Text(store.address)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 10) {
                                HStack(spacing: 4) {
                                    Circle().fill(Color.green).frame(width: 6, height: 6)
                                    Text("營業中 (\(store.operatingHours))")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                }
                                Text("電話: \(store.phone)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Action Buttons Row (Map Navigation + Store Select - Requirement #4)
                    HStack(spacing: 10) {
                        Button(action: {
                            SoundManager.shared.playTapSound()
                            mapStoreTarget = store
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "map.fill")
                                    .font(.caption2)
                                Text("查看地圖導航")
                                    .font(.caption)
                                    .bold()
                            }
                            .foregroundColor(Color(hex: "008B47"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(hex: "008B47").opacity(0.12))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        if store.id != selectedStore.id {
                            Button("選擇此門市") {
                                SoundManager.shared.playTapSound()
                                selectedStore = store
                            }
                            .font(.caption)
                            .bold()
                            .buttonStyle(.borderedProminent)
                            .tint(Color(hex: "008B47"))
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("台南市清心福全門市據點")
            .sheet(item: $mapStoreTarget) { store in
                StoreMapSheet(store: store)
            }
        }
    }
}

struct OrderHistoryView: View {
    let orders: [CompletedOrder]
    
    var body: some View {
        NavigationStack {
            Group {
                if orders.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("目前尚無歷史訂單")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("完成點餐後，訂單紀錄將會自動儲存在這裡！")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(orders) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    HStack(spacing: 6) {
                                        Text(order.orderModeName)
                                            .font(.system(size: 9, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(hex: "008B47").opacity(0.15))
                                            .foregroundColor(Color(hex: "008B47"))
                                            .clipShape(Capsule())
                                        
                                        Text(order.storeName)
                                            .font(.headline)
                                            .bold()
                                    }
                                    Spacer()
                                    Text(order.status)
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                                
                                Text("訂單編號: \(order.orderNo) ‧ \(order.dateString)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(order.items) { item in
                                        HStack {
                                            Text("‧ \(item.drink.name)")
                                                .font(.subheadline)
                                                .bold()
                                            Text("(\(item.customizationSummary))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Text("x\(item.quantity)")
                                                .font(.caption)
                                                .bold()
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("共 \(order.items.reduce(0) { $0 + $1.quantity }) 杯飲料")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("實付金額: NT$ \(order.totalPrice)")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("歷史訂單紀錄")
        }
    }
}
