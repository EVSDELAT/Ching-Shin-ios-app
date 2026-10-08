import SwiftUI

struct StoreLocatorView: View {
    @Binding var selectedStore: Store
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
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
                        LazyVStack(spacing: 10) {
                            ForEach(filteredStores) { store in
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    selectedStore = store
                                    dismiss()
                                }) {
                                    HStack(alignment: .top, spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(store.id == selectedStore.id ? AppTheme.primaryGreen : AppTheme.inputBg(isDarkMode))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: store.id == selectedStore.id ? "checkmark" : "mappin.and.ellipse")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(store.id == selectedStore.id ? .white : AppTheme.primaryGreen)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(store.name)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(AppTheme.textPrimary(isDarkMode))
                                                    .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                if !store.city.isEmpty {
                                                    Text(store.city)
                                                        .font(.system(size: 10, weight: .bold))
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(AppTheme.primaryGreen.opacity(0.12))
                                                        .foregroundColor(AppTheme.primaryGreen)
                                                        .clipShape(Capsule())
                                                }
                                            }
                                            
                                            Text(store.address)
                                                .font(.system(size: 12))
                                                .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                                .lineLimit(1)
                                            
                                            HStack(spacing: 12) {
                                                HStack(spacing: 4) {
                                                    Circle().fill(Color.green).frame(width: 6, height: 6)
                                                    Text("營業中 (\(store.operatingHours))")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(Color.green)
                                                }
                                                
                                                if !store.phone.isEmpty {
                                                    Text("電話: \(store.phone)")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(AppTheme.textSecondary(isDarkMode))
                                                }
                                            }
                                            .padding(.top, 2)
                                        }
                                    }
                                    .padding(14)
                                    .background(AppTheme.cardBg(isDarkMode))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(store.id == selectedStore.id ? AppTheme.primaryGreen : AppTheme.border(isDarkMode), lineWidth: store.id == selectedStore.id ? 2 : 1)
                                    )
                                    .shadow(color: Color.black.opacity(isDarkMode ? 0.3 : 0.04), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("全台門市據點")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppTheme.textSecondary(isDarkMode))
                    }
                }
            }
        }
    }
}
