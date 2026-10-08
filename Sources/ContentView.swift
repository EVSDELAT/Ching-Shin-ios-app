import SwiftUI

struct ContentView: View {
    @State private var cartItems: [CartItem] = []
    @State private var selectedDrink: Drink? = nil
    @State private var selectedStore: Store = SampleData.sampleStores[0]
    @State private var isShowingCart: Bool = false
    @State private var isShowingStoreLocator: Bool = false
    @State private var isShowingOrderProgress: Bool = false
    @State private var cartBounceScale: CGFloat = 1.0
    
    var totalCartItemsCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalCartPrice: Int {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Tab View
            TabView {
                MenuView(
                    cartItems: $cartItems,
                    currentStore: $selectedStore,
                    onSelectDrink: { drink in
                        selectedDrink = drink
                    },
                    onOpenCart: {
                        isShowingCart = true
                    },
                    onOpenStoreLocator: {
                        isShowingStoreLocator = true
                    }
                )
                .tabItem {
                    Label("菜單點餐", systemImage: "cup.and.saucer.fill")
                }
                
                StoreLocatorMainView(selectedStore: $selectedStore)
                .tabItem {
                    Label("門市據點", systemImage: "mappin.and.ellipse")
                }
                
                MemberCardView()
                .tabItem {
                    Label("會員專區", systemImage: "person.crop.square.fill")
                }
                
                OrderHistoryView()
                .tabItem {
                    Label("歷史訂單", systemImage: "clock.fill")
                }
            }
            .accentColor(Color(hex: "008B47"))
            
            // Floating Cart Action Bar (When items present)
            if !cartItems.isEmpty {
                VStack {
                    Button(action: {
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
                                Text("購物車已選取的飲料 (\(totalCartItemsCount)杯)")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("\(selectedStore.name) ‧ 點擊確認明細")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            
                            Spacer()
                            
                            Text("NT$ \(totalCartPrice)")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "00A550"), Color(hex: "008B47")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color(hex: "008B47").opacity(0.4), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 54)
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: cartItems.count)
            }
        }
        // Drink Customization Modal Sheet
        .sheet(item: $selectedDrink) { drink in
            DrinkDetailView(drink: drink) { newItem in
                withAnimation(.spring()) {
                    cartItems.append(newItem)
                    triggerCartBounce()
                }
            }
        }
        // Cart Summary Modal Sheet
        .sheet(isPresented: $isShowingCart) {
            CartView(cartItems: $cartItems) {
                cartItems.removeAll()
                isShowingOrderProgress = true
            }
        }
        // Store Locator Modal Sheet
        .sheet(isPresented: $isShowingStoreLocator) {
            StoreLocatorView(selectedStore: $selectedStore)
        }
        // Order Progress Simulation Screen
        .fullScreenCover(isPresented: $isShowingOrderProgress) {
            OrderProgressView()
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

// MARK: - Subviews for Store & History Tabs
struct StoreLocatorMainView: View {
    @Binding var selectedStore: Store
    
    var body: some View {
        NavigationStack {
            List(SampleData.sampleStores) { store in
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "008B47"))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(store.name)
                                .font(.headline)
                            if store.id == selectedStore.id {
                                Text("目前選擇")
                                    .font(.system(size: 9, weight: .bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(hex: "008B47"))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        Text(store.address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("選擇") {
                        selectedStore = store
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "008B47"))
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("門市據點搜尋")
        }
    }
}

struct OrderHistoryView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("近期訂單紀錄")) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("清心福全 台南總店")
                                .font(.headline)
                            Spacer()
                            Text("已完成")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.green)
                        }
                        Text("珍珠鮮奶茶(大杯/半糖/微冰) x1, 烏龍綠茶(大杯/無糖/去冰) x1")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("2026/10/08 10:30")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("NT$ 105")
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("歷史訂單紀錄")
        }
    }
}
