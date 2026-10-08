import SwiftUI

// MARK: - App Version
struct AppInfo {
    static let version = "v1.0.0"
    static let appName = "清心福全"
}

// MARK: - Official Menu Categories (依照清心福全官方菜單分類)
enum DrinkCategory: String, CaseIterable, Identifiable {
    case popular = "清心推薦"
    case premiumTea = "茗品系列"
    case winterMelon = "冬瓜/百香果"
    case freshJuice = "季節鮮果"
    case freshMilkLatte = "鮮奶/拿鐵"
    case milkTea = "奶茶系列"
    case yogurt = "優多系列"
    case vinegar = "果醋系列"
    case specialty = "特調系列"
    case iceCream = "冰淇淋系列"
    case hotSpecial = "冬季熱飲"
    case limited = "限定販售"
    case hiddenSecret = "隱藏版特調"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .popular: return "star.fill"
        case .premiumTea: return "leaf.fill"
        case .winterMelon: return "drop.fill"
        case .freshJuice: return "sun.max.fill"
        case .freshMilkLatte: return "cup.and.saucer.fill"
        case .milkTea: return "drop.circle.fill"
        case .yogurt: return "heart.fill"
        case .vinegar: return "sparkles"
        case .specialty: return "wand.and.stars"
        case .iceCream: return "snowflake"
        case .hotSpecial: return "flame.fill"
        case .limited: return "crown.fill"
        case .hiddenSecret: return "sparkle"
        }
    }
}

// MARK: - Sugar & Ice Options (符合清心官方甜度冰量圖示)
enum SugarLevel: String, CaseIterable, Identifiable {
    case regular = "正常糖 (100%)"
    case less8 = "少糖 (80%)"
    case half5 = "半糖 (50%)"
    case micro2 = "微糖 (20%)"
    case zero = "無糖 (0%)"
    
    var id: String { self.rawValue }
    
    var shortName: String {
        switch self {
        case .regular: return "正常糖"
        case .less8: return "少糖(8分)"
        case .half5: return "半糖(5分)"
        case .micro2: return "微糖(2分)"
        case .zero: return "無糖(0分)"
        }
    }
}

enum IceLevel: String, CaseIterable, Identifiable {
    case regular = "正常冰 (100%)"
    case lessIce = "少冰 (70%)"
    case microIce = "微冰 (30%)"
    case noIce = "去冰 (0%)"
    case warm = "溫飲"
    case hot = "熱飲"
    
    var id: String { self.rawValue }
    
    var shortName: String {
        switch self {
        case .regular: return "正常冰"
        case .lessIce: return "少冰"
        case .microIce: return "微冰"
        case .noIce: return "去冰"
        case .warm: return "溫飲"
        case .hot: return "熱飲"
        }
    }
    
    var iconName: String {
        switch self {
        case .regular, .lessIce, .microIce: return "snowflake"
        case .noIce: return "drop.slash.fill"
        case .warm, .hot: return "flame.fill"
        }
    }
}

// MARK: - Official Toppings (清心官方完整加料)
enum Topping: String, CaseIterable, Identifiable {
    case redBean = "紅豆 (+10)"
    case greenTeaJelly = "茶凍 (+10)"
    case peachJam = "蜜桃醬 (+10)"
    case coconut = "椰果 (+10)"
    case boba = "珍珠 (+10)"
    case qq = "QQ (+10)"
    case miniPearl = "粉圓 (+10)"
    case iceCream = "冰淇淋 (+15)"
    case grassJelly = "仙草凍 (+10)"
    case coffeeJelly = "咖啡凍 (+10)"
    case aloe = "蘆薈 (+15)"
    case pudding = "布丁 (+15)"
    
    var id: String { self.rawValue }
    
    var price: Int {
        switch self {
        case .redBean, .greenTeaJelly, .peachJam, .coconut, .boba, .qq, .miniPearl, .grassJelly, .coffeeJelly: return 10
        case .iceCream, .aloe, .pudding: return 15
        }
    }
    
    var cleanName: String {
        switch self {
        case .redBean: return "紅豆"
        case .greenTeaJelly: return "茶凍"
        case .peachJam: return "蜜桃醬"
        case .coconut: return "椰果"
        case .boba: return "珍珠"
        case .qq: return "QQ"
        case .miniPearl: return "粉圓"
        case .iceCream: return "冰淇淋"
        case .grassJelly: return "仙草凍"
        case .coffeeJelly: return "咖啡凍"
        case .aloe: return "蘆薈"
        case .pudding: return "布丁"
        }
    }
}

enum CupSize: String, CaseIterable, Identifiable {
    case medium = "中杯 (M)"
    case large = "大杯 (L)"
    
    var id: String { self.rawValue }
}

// MARK: - Store Model (門市資訊)
struct Store: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let phone: String
    let distance: String
    let isOpen: Bool
    let operatingHours: String
}

// MARK: - Drink Model
struct Drink: Identifiable {
    let id = UUID()
    let name: String
    let category: DrinkCategory
    let priceM: Int?
    let priceL: Int
    let description: String
    let isHotItem: Bool
    let cupStyle: CupVisualType
}

enum CupVisualType {
    case bobaMilkTea
    case greenTea
    case fruitTea
    case hiddenSpecial
    case redTea
    case iceCreamType
    case hotSpecialType
}

// MARK: - Cart Item
struct CartItem: Identifiable {
    let id = UUID()
    let drink: Drink
    var size: CupSize
    var sugar: SugarLevel
    var ice: IceLevel
    var toppings: Set<Topping>
    var quantity: Int
    
    var unitPrice: Int {
        let base = (size == .medium && drink.priceM != nil) ? drink.priceM! : drink.priceL
        let toppingCost = toppings.reduce(0) { $0 + $1.price }
        return base + toppingCost
    }
    
    var totalPrice: Int {
        unitPrice * quantity
    }
    
    var customizationSummary: String {
        var parts = ["\(size.rawValue)", sugar.shortName, ice.shortName]
        if !toppings.isEmpty {
            let toppingNames = toppings.map { $0.cleanName }.joined(separator: "+")
            parts.append("加: \(toppingNames)")
        }
        return parts.joined(separator: " / ")
    }
}

// MARK: - Official Sample Data (依據使用者上傳清心菜單完全對應)
struct SampleData {
    static let sampleStores: [Store] = [
        Store(name: "清心福全 台南總店", address: "台南市中西區西門路二段222號", phone: "06-2288899", distance: "1.2 km", isOpen: true, operatingHours: "09:00 - 22:00"),
        Store(name: "清心福全 台北西門店", address: "台北市萬華區成都路48號", phone: "02-23881122", distance: "3.5 km", isOpen: true, operatingHours: "09:30 - 22:30"),
        Store(name: "清心福全 台中一中店", address: "台中市北區三民路三段120號", phone: "04-22253344", distance: "4.1 km", isOpen: true, operatingHours: "09:00 - 22:00"),
        Store(name: "清心福全 高雄新堀江店", address: "高雄市新興區文橫二路143號", phone: "07-2815566", distance: "8.0 km", isOpen: true, operatingHours: "10:00 - 23:00")
    ]
    
    static let drinks: [Drink] = [
        // 茗品系列
        Drink(name: "烏龍綠茶", category: .premiumTea, priceM: 30, priceL: 35, description: "清心福全鎮店之寶！高山烏龍與清香綠茶完美調和。", isHotItem: true, cupStyle: .greenTea),
        Drink(name: "特級綠茶", category: .premiumTea, priceM: 30, priceL: 35, description: "嚴選優質綠茶，清香怡人回甘無窮。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "錫蘭紅茶", category: .premiumTea, priceM: 30, priceL: 35, description: "濃郁麥芽果香，茶湯紅潤滑順。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "極品烏龍", category: .premiumTea, priceM: 30, priceL: 35, description: "喉韻甘醇，傳統烏龍茶香四溢。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "原鄉四季", category: .premiumTea, priceM: 30, priceL: 35, description: "獨特花香韻味，清爽順口。", isHotItem: false, cupStyle: .greenTea),
        
        // 鮮奶 / 拿鐵系列
        Drink(name: "珍珠鮮奶茶", category: .freshMilkLatte, priceM: 55, priceL: 70, description: "手作Q彈珍珠，搭配小農鮮乳與厚香紅茶。", isHotItem: true, cupStyle: .bobaMilkTea),
        Drink(name: "【隱藏版】珍珠蜂蜜鮮奶普洱", category: .hiddenSecret, priceM: 55, priceL: 75, description: "網路推爆神級隱藏版！蜂蜜點綴厚實普洱與鮮奶雙料。", isHotItem: true, cupStyle: .hiddenSpecial),
        Drink(name: "茉綠茶凍拿鐵", category: .freshMilkLatte, priceM: nil, priceL: 70, description: "手作茉綠茶凍，搭配香濃鮮奶拿鐵。", isHotItem: true, cupStyle: .greenTea),
        Drink(name: "頂級可可拿鐵", category: .freshMilkLatte, priceM: 65, priceL: 85, description: "濃郁頂級可可與純濃鮮奶的奢華風味。", isHotItem: false, cupStyle: .redTea),
        
        // 奶茶系列
        Drink(name: "珍珠/粉圓奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "經典經典手搖奶茶搭配彈牙珍珠或粉圓。", isHotItem: true, cupStyle: .bobaMilkTea),
        Drink(name: "相思紅豆奶茶", category: .milkTea, priceM: 60, priceL: 70, description: "綿密紅豆與濃郁奶茶交織的甜蜜口感。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "仙草凍奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "滑嫩仙草凍遇上香醇奶茶，消暑首選。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "布丁奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "完整滑嫩布丁融入經典奶茶。", isHotItem: true, cupStyle: .bobaMilkTea),
        
        // 季節鮮果系列
        Drink(name: "紅柚茶凍綠", category: .freshJuice, priceM: nil, priceL: 80, description: "鮮果紅柚果肉與清香綠茶凍極致震撼。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "紅柚綠茶", category: .freshJuice, priceM: nil, priceL: 70, description: "現採紅柚果汁與清新綠茶酸甜開胃。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蘆薈蜜香檸檬", category: .freshJuice, priceM: 70, priceL: 90, description: "清爽蘆薈果肉與天然蜂蜜檸檬調和。", isHotItem: false, cupStyle: .fruitTea),
        
        // 優多系列
        Drink(name: "優多紅柚茶凍", category: .yogurt, priceM: nil, priceL: 85, description: "乳酸優多結合新鮮紅柚與特製茶凍。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "優多綠茶", category: .yogurt, priceM: nil, priceL: 55, description: "經典酸甜乳酸優多與綠茶碰撞。", isHotItem: true, cupStyle: .greenTea),
        
        // 冰淇淋與限定系列
        Drink(name: "【紅茶三兄弟】珍珠冰淇淋布丁紅茶", category: .iceCream, priceM: nil, priceL: 75, description: "超澎湃三料！珍珠+冰淇淋+布丁組合。", isHotItem: true, cupStyle: .iceCreamType),
        Drink(name: "厚雪烏龍奶蓋", category: .limited, priceM: nil, priceL: 60, description: "鹹甜濃郁厚雪奶蓋覆蓋香醇烏龍。", isHotItem: true, cupStyle: .hiddenSpecial),
        
        // 冬季熱飲系列
        Drink(name: "白醇杏仁鮮奶", category: .hotSpecial, priceM: nil, priceL: 85, description: "香濃溫潤白醇杏仁與小農鮮奶暖心熱飲。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "薑薑奶茶", category: .hotSpecial, priceM: 55, priceL: 70, description: "老薑微辣香氣與暖心奶茶。", isHotItem: false, cupStyle: .hotSpecialType)
    ]
}

// MARK: - Color Hex Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
