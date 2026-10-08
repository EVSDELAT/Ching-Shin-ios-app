import SwiftUI

struct StoreLocatorView: View {
    @Binding var stores: [Store]
    @Binding var currentStore: Store
    
    @State private var searchText: String = ""
    
    var filteredStores: [Store] {
        if searchText.isEmpty {
            return stores
        } else {
            return stores.filter { $0.name.contains(searchText) || $0.address.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ChingShinTheme.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Header
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("搜尋縣市、門市名稱（如：信義、台南...）", text: $searchText)
                    }
                    .padding(12)
                    .background(ChingShinTheme.cardBackground)
                    .cornerRadius(14)
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(filteredStores) { store in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(store.name)
                                                    .font(.headline)
                                                if currentStore.id == store.id {
                                                    Text("目前選擇")
                                                        .font(.caption2.bold())
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(ChingShinTheme.lightGreen)
                                                        .foregroundColor(ChingShinTheme.darkGreen)
                                                        .cornerRadius(6)
                                                }
                                            }
                                            
                                            Text(store.address)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if let idx = stores.firstIndex(where: { $0.id == store.id }) {
                                                stores[idx].isFavorite.toggle()
                                            }
                                        }) {
                                            Image(systemName: store.isFavorite ? "heart.fill" : "heart")
                                                .foregroundColor(store.isFavorite ? .red : .gray)
                                                .font(.title3)
                                        }
                                    }
                                    
                                    HStack {
                                        Label(store.businessHours, systemImage: "clock")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Label("\(String(format: "%.1f", store.distanceKm)) km", systemImage: "location.fill")
                                            .font(.caption.bold())
                                            .foregroundColor(ChingShinTheme.primaryGreen)
                                    }
                                    
                                    Divider()
                                    
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            currentStore = store
                                        }) {
                                            Text(currentStore.id == store.id ? "已選擇此門市" : "設為點餐門市")
                                                .font(.caption.bold())
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(currentStore.id == store.id ? ChingShinTheme.lightGreen : ChingShinTheme.primaryGreen)
                                                .foregroundColor(currentStore.id == store.id ? ChingShinTheme.darkGreen : .white)
                                                .cornerRadius(10)
                                        }
                                        
                                        Button(action: {}) {
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(ChingShinTheme.primaryGreen)
                                                .padding(8)
                                                .background(ChingShinTheme.lightGreen)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(ChingShinTheme.cardBackground)
                                .cornerRadius(18)
                                .shadow(color: Color.black.opacity(0.03), radius: 6, y: 3)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("門市據點搜尋")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
