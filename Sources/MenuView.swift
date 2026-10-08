import SwiftUI

struct MenuView: View {
    @Binding var cartItems: [CartItem]
    @Binding var currentStore: Store
    var onSelectDrink: (Drink) -> Void
    var onOpenCart: () -> Void
    var onOpenStoreLocator: () -> Void
    
    @State private var selectedCategory: DrinkCategory = .popular
    @State private var searchText: String = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var filteredDrinks: [Drink] {
        SampleData.drinks.filter { drink in
            let matchesCategory = (selectedCategory == .popular) || (drink.category == selectedCategory)
            let matchesSearch = searchText.isEmpty || drink.name.contains(searchText) || drink.description.contains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Store Selector Header
                Button(action: onOpenStoreLocator) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "008B47"))
                                .frame(width: 36, height: 36)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(currentStore.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 6, height: 6)
                                    Text("營業中")
                                        .font(.caption2)
                                        .bold()
                                        .foregroundColor(.green)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.12))
                                .clipShape(Capsule())
                            }
                            
                            Text("\(currentStore.address) ‧ 約 \(currentStore.distance)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                }
                .buttonStyle(.plain)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜尋清心飲料（如：紅柚綠、烏龍綠、隱藏版...）", text: $searchText)
                        .font(.subheadline)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Hero PROMO Banner Card
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "008B47"), Color(hex: "00572C")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(spacing: 6) {
                                        Text("PROMO 招牌特調")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Color.yellow)
                                            .foregroundColor(.black)
                                            .clipShape(Capsule())
                                        
                                        Text("清心經典重現")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    
                                    Text("隱藏版 珍珠蜂蜜鮮奶普洱")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Text("高山普洱與濃香奶味，雙料爆棚極致口感！")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.85))
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Drink3DThumbnailView(style: .hiddenSpecial, size: 75)
                            }
                            .padding(16)
                        }
                        .frame(height: 110)
                        .padding(.horizontal, 16)
                        
                        // Official Category Pills Bar (依據清心菜單所有分類)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(DrinkCategory.allCases) { category in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedCategory = category
                                        }
                                    }) {
                                        HStack(spacing: 5) {
                                            Image(systemName: category.iconName)
                                                .font(.caption)
                                            Text(category.rawValue)
                                                .font(.subheadline)
                                                .fontWeight(selectedCategory == category ? .bold : .semibold)
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color(hex: "008B47") : Color.gray.opacity(0.12))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .clipShape(Capsule())
                                        .shadow(color: selectedCategory == category ? Color(hex: "008B47").opacity(0.3) : Color.clear, radius: 4, y: 2)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // 2-Column Grid Layout (真實菜單價格與雙排卡片)
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(filteredDrinks) { drink in
                                DrinkGridCard(drink: drink) {
                                    onSelectDrink(drink)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 90)
                    }
                    .padding(.top, 4)
                }
            }
            .navigationBarHidden(true)
            .background(Color(hex: "F8F9FA"))
        }
    }
}

// MARK: - 2-Column Drink Grid Card (真實菜單 M/L 標價卡片)
struct DrinkGridCard: View {
    let drink: Drink
    let onTap: () -> Void
    
    var priceText: String {
        if let pM = drink.priceM {
            return "M$ \(pM) / L$ \(drink.priceL)"
        } else {
            return "L$ \(drink.priceL)"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // 3D Drink Image Box
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "F3F4F6"))
                        .frame(height: 120)
                    
                    Drink3DThumbnailView(style: drink.cupStyle, size: 85)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    if drink.isHotItem {
                        Text("HOT 熱銷")
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
                
                // Drink Title & Desc
                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(drink.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .frame(height: 28, alignment: .topLeading)
                    
                    HStack {
                        Text(priceText)
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color(hex: "008B47"))
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "008B47"))
                                .frame(width: 26, height: 26)
                            Image(systemName: "plus")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
