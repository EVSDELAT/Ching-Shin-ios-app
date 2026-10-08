import SwiftUI

struct StoreLocatorView: View {
    @Binding var selectedStore: Store
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var selectedCity: String = "全部"
    @State private var selectedDistrict: String = "全部鄉鎮"
    @State private var searchStoreText: String = ""
    @State private var isLocating: Bool = false
    @State private var locationNotice: String? = nil
    
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
                        
                        // Row 2: GPS Auto Location Button
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
                                Text(isLocating ? "正在取得 GPS 定位..." : "自動定位 (依目前 GPS 篩選最近門市)")
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
                        
                        // Row 3: Search Bar
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
                                Text("共篩選出 \(filteredStores.count) 家門市")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
                            }
                            Spacer()
                        }
                    }
                    .padding(14)
                    
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
                                                
                                                if !store.district.isEmpty {
                                                    Text(store.district)
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
