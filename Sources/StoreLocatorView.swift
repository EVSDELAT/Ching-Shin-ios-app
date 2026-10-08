import SwiftUI

struct StoreLocatorView: View {
    @Binding var selectedStore: Store
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var searchStoreText: String = ""
    
    var filteredStores: [Store] {
        SampleData.sampleStores.filter { store in
            searchStoreText.isEmpty || store.name.contains(searchStoreText) || store.address.contains(searchStoreText)
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
                        TextField("搜尋門市名稱或地址...", text: $searchStoreText)
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
                    .padding(16)
                    
                    // Store List
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(filteredStores) { store in
                                Button(action: {
                                    SoundManager.shared.playTapSound()
                                    selectedStore = store
                                    dismiss() // Requirement 3: Auto jump back to menu main page
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
                                                
                                                Text(store.distance)
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(AppTheme.primaryGreen)
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
                                                
                                                Text("電話: \(store.phone)")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(AppTheme.textSecondary(isDarkMode))
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
            .navigationTitle("門市據點")
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
