import SwiftUI

struct MainTabView: View {
    @State private var cartItems: [CartItem] = []
    @State private var stores: [Store] = MockData.sampleStores
    @State private var currentStore: Store = MockData.sampleStores[0]
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MenuView(
                cartItems: $cartItems,
                currentStore: $currentStore,
                stores: $stores
            )
            .tabItem {
                Label("線上點餐", systemImage: "cup.and.saucer.fill")
            }
            .tag(0)
            
            MemberCardView()
                .tabItem {
                    Label("會員優惠", systemImage: "ticket.fill")
                }
                .tag(1)
            
            StoreLocatorView(stores: $stores, currentStore: $currentStore)
                .tabItem {
                    Label("門市據點", systemImage: "mappin.and.ellipse")
                }
                .tag(2)
            
            OrderTrackingView()
                .tabItem {
                    Label("訂單追蹤", systemImage: "clock.badge.checkmark.fill")
                }
                .badge(cartItems.count > 0 ? "新" : nil)
                .tag(3)
        }
        .tint(ChingShinTheme.primaryGreen)
    }
}
