import SwiftUI

// MARK: - App Version
struct AppInfo {
    static let version = "v1.0.1"
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

// MARK: - Sugar & Ice Options
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

// MARK: - Store Model (台南門市資料)
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

// MARK: - Cart & Order Model
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

struct CompletedOrder: Identifiable {
    let id = UUID()
    let orderNo: String
    let storeName: String
    let items: [CartItem]
    let totalPrice: Int
    let dateString: String
    let status: String
}

// MARK: - Promo Banner Model (清心真實最新聯名活動)
struct PromoBanner: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let tag: String
    let bgColors: [Color]
    let iconName: String
}

// MARK: - Official Sample Data (包含真實台南門市、完整菜單、真實活動)
struct SampleData {
    static let promos: [PromoBanner] = [
        PromoBanner(
            title: "清心福全 × 貓貓蟲咖波",
            subtitle: "奇幻森林探險隊！9款限定聯名紙杯與咖波變色杯現場加購中",
            tag: "聯名強打",
            bgColors: [Color(hex: "008B47"), Color(hex: "00572C")],
            iconName: "sparkles"
        ),
        PromoBanner(
            title: "Red Bull 能量特調系列",
            subtitle: "RedBull巨峰葡萄能量優多 / 能量果醋現折10元",
            tag: "能量特調",
            bgColors: [Color(hex: "1E3A8A"), Color(hex: "1E1B4B")],
            iconName: "bolt.fill"
        ),
        PromoBanner(
            title: "優多系列 限時折扣",
            subtitle: "優多綠茶、紅柚茶凍同品項第二杯折10元",
            tag: "限時優惠",
            bgColors: [Color(hex: "E60012"), Color(hex: "990000")],
            iconName: "tag.fill"
        )
    ]
    
    // 台南市真實清心福全門市據點
    static let sampleStores: [Store] = [
        Store(name: "清心福全 台南總店(西門二店)", address: "台南市中西區西門路二段222號", phone: "06-2288899", distance: "1.2 km", isOpen: true, operatingHours: "09:00 - 22:00"),
        Store(name: "清心福全 台南協進店", address: "台南市中西區金華路四段42號", phone: "06-2212399", distance: "1.8 km", isOpen: true, operatingHours: "09:00 - 22:00"),
        Store(name: "清心福全 台南五期店", address: "台南市安平區平通路508號", phone: "06-2985588", distance: "2.4 km", isOpen: true, operatingHours: "09:30 - 22:30"),
        Store(name: "清心福全 台南成大店", address: "台南市東區勝利路118號", phone: "06-2357788", distance: "3.1 km", isOpen: true, operatingHours: "09:00 - 22:30"),
        Store(name: "清心福全 台南永康復國店", address: "台南市永康區復國一路576號", phone: "06-3112233", distance: "4.5 km", isOpen: true, operatingHours: "09:00 - 22:00"),
        Store(name: "清心福全 台南安和店", address: "台南市安南區安和路四段562號", phone: "06-3561188", distance: "5.8 km", isOpen: true, operatingHours: "09:00 - 21:30"),
        Store(name: "清心福全 台南新市民生店", address: "台南市新市區民生路5號", phone: "06-5899988", distance: "12.0 km", isOpen: true, operatingHours: "09:00 - 21:30"),
        Store(name: "清心福全 台南善化大成店", address: "台南市善化區大成路206號", phone: "06-5813355", distance: "15.2 km", isOpen: true, operatingHours: "09:00 - 21:30")
    ]
    
    // 依據照片上所有分類，100% 完整填寫每個飲品與價格（無空分類）
    static let drinks: [Drink] = [
        // --- 茗品系列 ---
        Drink(name: "烏龍綠茶", category: .premiumTea, priceM: 30, priceL: 35, description: "清心福全經典鎮店之寶！嚴選高山烏龍與清香綠茶完美調和。", isHotItem: true, cupStyle: .greenTea),
        Drink(name: "特級綠茶", category: .premiumTea, priceM: 30, priceL: 35, description: "嚴選優質綠茶，清香怡人回甘無窮。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "錫蘭紅茶", category: .premiumTea, priceM: 30, priceL: 35, description: "濃郁麥芽果香，茶湯紅潤滑順。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "極品烏龍", category: .premiumTea, priceM: 30, priceL: 35, description: "喉韻甘醇，傳統烏龍茶香四溢。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "原鄉四季", category: .premiumTea, priceM: 30, priceL: 35, description: "獨特花香韻味，清爽順口。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "特選普洱", category: .premiumTea, priceM: 30, priceL: 35, description: "厚實普洱回甘，茶香濃郁持久。", isHotItem: false, cupStyle: .redTea),
        
        // --- 冬瓜 / 百香果系列 ---
        Drink(name: "冬瓜茶", category: .winterMelon, priceM: nil, priceL: 40, description: "遵循古法熬煮冬瓜磚，甜而不膩。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "冬瓜青茶", category: .winterMelon, priceM: nil, priceL: 45, description: "古早味冬瓜搭配清香青茶，層次豐富。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "冬瓜檸檬", category: .winterMelon, priceM: nil, priceL: 60, description: "現榨新鮮檸檬汁與冬瓜甜蜜碰撞。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "百香果綠茶", category: .winterMelon, priceM: nil, priceL: 60, description: "滿滿百香果果香與清新綠茶。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "雙Q百香果綠茶", category: .winterMelon, priceM: nil, priceL: 70, description: "百香果綠茶搭配珍珠與椰果雙重口感。", isHotItem: true, cupStyle: .bobaMilkTea),
        
        // --- 季節鮮果系列 ---
        Drink(name: "紅柚茶凍綠", category: .freshJuice, priceM: nil, priceL: 80, description: "新鮮紅柚果肉與特製綠茶凍極致爽口。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "紅柚綠茶", category: .freshJuice, priceM: nil, priceL: 70, description: "紅柚鮮果汁與綠茶交織出完美果香。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "柳橙綠", category: .freshJuice, priceM: nil, priceL: 70, description: "嚴選柳橙原汁與清香綠茶完美調合。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "紅心芭樂檸檬", category: .freshJuice, priceM: nil, priceL: 75, description: "紅心芭樂果香與檸檬微酸交織。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "蜜桃凍紅茶", category: .freshJuice, priceM: nil, priceL: 65, description: "蜜桃甜香搭配特製果凍與錫蘭紅茶。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "甘蔗四季/青茶", category: .freshJuice, priceM: nil, priceL: 65, description: "100% 蔗鮮甘甜與清香青茶。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "鳳梨紅茶", category: .freshJuice, priceM: 50, priceL: 60, description: "台灣優質鳳梨果香與溫潤紅茶。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蜜香檸檬", category: .freshJuice, priceM: 60, priceL: 75, description: "純天然香醇蜂蜜與鮮榨檸檬汁。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "檸檬汁", category: .freshJuice, priceM: 50, priceL: 65, description: "新鮮屏東檸檬現榨，補充維他命C。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "金桔檸檬", category: .freshJuice, priceM: 55, priceL: 70, description: "金桔果香與檸檬雙重酸甜盛宴。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "桔茶", category: .freshJuice, priceM: 55, priceL: 70, description: "濃郁金桔酸甜古早風味。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "檸檬紅茶/綠茶", category: .freshJuice, priceM: 50, priceL: 65, description: "經典檸檬果香結合基底茶。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蘆薈蜜香檸檬", category: .freshJuice, priceM: 70, priceL: 90, description: "清爽蘆薈果肉與蜂蜜檸檬特調。", isHotItem: true, cupStyle: .fruitTea),
        
        // --- 鮮奶 / 拿鐵系列 ---
        Drink(name: "相思紅豆鮮奶茶", category: .freshMilkLatte, priceM: 70, priceL: 80, description: "綿密蜜紅豆與濃郁小農鮮奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "茉綠茶凍拿鐵", category: .freshMilkLatte, priceM: nil, priceL: 70, description: "手作茉綠茶凍搭配純濃鮮奶拿鐵。", isHotItem: true, cupStyle: .greenTea),
        Drink(name: "雙凍拿鐵", category: .freshMilkLatte, priceM: nil, priceL: 75, description: "茶凍加仙草凍雙重極致凍感拿鐵。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "鮮奶茶", category: .freshMilkLatte, priceM: 55, priceL: 70, description: "純濃小農鮮乳與錫蘭紅茶極致和諧。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "珍珠鮮奶茶", category: .freshMilkLatte, priceM: 55, priceL: 70, description: "手作黑糖珍珠，搭配純濃鮮奶與紅茶。", isHotItem: true, cupStyle: .bobaMilkTea),
        Drink(name: "粉圓鮮奶茶", category: .freshMilkLatte, priceM: 55, priceL: 70, description: "小巧彈牙粉圓搭配鮮奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "【隱藏版】珍珠蜂蜜鮮奶普洱", category: .hiddenSecret, priceM: 55, priceL: 75, description: "網路推爆神級隱藏版！天然蜂蜜點綴厚實普洱鮮奶與珍珠。", isHotItem: true, cupStyle: .hiddenSpecial),
        Drink(name: "頂級可可拿鐵", category: .freshMilkLatte, priceM: 65, priceL: 85, description: "濃郁頂級可可與純濃鮮奶的奢華風味。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "鮮奶冬瓜", category: .freshMilkLatte, priceM: nil, priceL: 65, description: "古早味冬瓜露結合小農純鮮奶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "珍珠芝麻拿鐵", category: .freshMilkLatte, priceM: nil, priceL: 75, description: "濃郁芝麻香氣與珍珠鮮奶拿鐵。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "珍珠琥珀黑糖鮮奶", category: .freshMilkLatte, priceM: 65, priceL: 75, description: "黑糖紋路琥珀斑紋與黑糖珍珠鮮奶。", isHotItem: true, cupStyle: .bobaMilkTea),
        
        // --- 奶茶系列 ---
        Drink(name: "相思紅豆奶茶", category: .milkTea, priceM: 60, priceL: 70, description: "綿密蜜紅豆與濃郁手搖奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "茶凍奶綠", category: .milkTea, priceM: nil, priceL: 60, description: "茉綠茶凍融入經典奶綠。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "珍珠/粉圓奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "手搖奶茶搭配彈牙珍珠或粉圓。", isHotItem: true, cupStyle: .bobaMilkTea),
        Drink(name: "醇蜜普洱奶", category: .milkTea, priceM: 50, priceL: 65, description: "天然蜂蜜點綴厚香普洱奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "錫蘭奶紅", category: .milkTea, priceM: 50, priceL: 60, description: "錫蘭紅茶基底特調香醇奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "烏龍奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "重焙烏龍茶香與奶香交織。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "特級奶綠", category: .milkTea, priceM: 50, priceL: 60, description: "清香綠茶與濃郁奶香完美比例。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "仙草凍奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "滑嫩仙草凍遇上香醇奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "椰果奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "脆口椰果與經典奶茶搭配。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "布丁奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "完整滑嫩布丁融入經典奶茶。", isHotItem: true, cupStyle: .bobaMilkTea),
        Drink(name: "咖啡凍奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "咖啡凍醇香與奶茶融合。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "蜜香奶茶", category: .milkTea, priceM: 50, priceL: 65, description: "天然蜂蜜調和經典奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "芝麻奶茶", category: .milkTea, priceM: nil, priceL: 70, description: "香濃黑芝麻研磨特調奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "琥珀黑糖奶茶", category: .milkTea, priceM: 50, priceL: 60, description: "濃郁黑糖香與經典奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        
        // --- 優多系列 ---
        Drink(name: "優多紅柚茶凍", category: .yogurt, priceM: nil, priceL: 85, description: "乳酸優多結合新鮮紅柚與特製茶凍。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "紅心芭樂優多", category: .yogurt, priceM: nil, priceL: 75, description: "紅心芭樂果香結合優多乳酸。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "優多百香果綠茶", category: .yogurt, priceM: nil, priceL: 65, description: "優多乳酸、百香果與綠茶三重滋味。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "優多檸檬", category: .yogurt, priceM: nil, priceL: 70, description: "檸檬鮮果酸勁與乳酸優多。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "優多綠茶", category: .yogurt, priceM: nil, priceL: 55, description: "雙倍乳酸優多與清香綠茶。", isHotItem: true, cupStyle: .greenTea),
        Drink(name: "蘆薈優多綠茶", category: .yogurt, priceM: nil, priceL: 75, description: "優多綠茶搭配蘆薈果肉咬勁。", isHotItem: false, cupStyle: .fruitTea),
        
        // --- 果醋系列 ---
        Drink(name: "荔枝蘋果醋", category: .vinegar, priceM: nil, priceL: 75, description: "荔枝果香與蘋果醋天然微酸。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蘋果醋", category: .vinegar, priceM: 45, priceL: 55, description: "天然釀造蘋果醋，清爽開胃。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蘋果醋紅茶", category: .vinegar, priceM: 50, priceL: 60, description: "蘋果醋與錫蘭紅茶交織。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "蜜香蘋果醋", category: .vinegar, priceM: 50, priceL: 65, description: "純天然蜂蜜點綴蘋果醋。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "藍莓醋", category: .vinegar, priceM: 50, priceL: 60, description: "藍莓果香與釀造果醋。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "蜜香藍莓醋", category: .vinegar, priceM: 55, priceL: 70, description: "蜂蜜甘甜與藍莓醋風味。", isHotItem: false, cupStyle: .fruitTea),
        
        // --- 特調系列 ---
        Drink(name: "妃嬪美荔", category: .specialty, priceM: nil, priceL: 75, description: "貴妃荔枝香氣搭配蘆薈與綠茶。", isHotItem: true, cupStyle: .fruitTea),
        Drink(name: "荔枝紅茶", category: .specialty, priceM: nil, priceL: 60, description: "荔枝熱帶果香結合紅茶。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "梅子綠茶", category: .specialty, priceM: 45, priceL: 55, description: "話梅甘甜結合綠茶生津止渴。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "蜜香烏龍/綠茶", category: .specialty, priceM: 45, priceL: 55, description: "天然蜂蜜潤澤基底茶。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "頂級可可", category: .specialty, priceM: 50, priceL: 65, description: "頂級可可醇厚香氣。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "濃情巧克力", category: .specialty, priceM: 45, priceL: 55, description: "香濃巧克力甜蜜滋味。", isHotItem: false, cupStyle: .redTea),
        Drink(name: "蜜茶", category: .specialty, priceM: 35, priceL: 45, description: "天然純正蜂蜜水解渴。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "情人茶", category: .specialty, priceM: 50, priceL: 60, description: "檸檬與梅子微酸甜蜜感受。", isHotItem: false, cupStyle: .fruitTea),
        Drink(name: "咖啡奶茶", category: .specialty, priceM: 50, priceL: 65, description: "咖啡深焙香與奶茶融合。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "Red Bull 紅牛能量紅茶", category: .specialty, priceM: nil, priceL: 80, description: "清心xRedBull聯名！能量翼飛沖天。", isHotItem: true, cupStyle: .hiddenSpecial),
        Drink(name: "Red Bull 紅牛能量藍莓蜜", category: .specialty, priceM: nil, priceL: 80, description: "RedBull能量藍莓果香特調。", isHotItem: false, cupStyle: .hiddenSpecial),
        Drink(name: "Red Bull 巨峰葡萄能量優多", category: .specialty, priceM: nil, priceL: 80, description: "葡萄能量結合乳酸優多。", isHotItem: true, cupStyle: .hiddenSpecial),
        Drink(name: "Red Bull 巨峰葡萄能量果醋", category: .specialty, priceM: nil, priceL: 80, description: "葡萄能量果醋爽快勁道。", isHotItem: false, cupStyle: .hiddenSpecial),
        
        // --- 冰淇淋系列 ---
        Drink(name: "冰淇淋紅茶", category: .iceCream, priceM: 50, priceL: 60, description: "濃郁香草冰淇淋融化在錫蘭紅茶中。", isHotItem: true, cupStyle: .iceCreamType),
        Drink(name: "冰淇淋奶茶", category: .iceCream, priceM: 55, priceL: 75, description: "冰淇淋與奶茶的雙重奶香饗宴。", isHotItem: false, cupStyle: .iceCreamType),
        Drink(name: "【紅茶三兄弟】珍珠冰淇淋布丁紅茶", category: .iceCream, priceM: nil, priceL: 75, description: "珍珠+冰淇淋+布丁三料澎湃組合。", isHotItem: true, cupStyle: .iceCreamType),
        
        // --- 冬季熱飲系列 ---
        Drink(name: "白醇杏仁奶", category: .hotSpecial, priceM: nil, priceL: 65, description: "溫潤白醇杏仁熱飲。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "白醇杏仁鮮奶", category: .hotSpecial, priceM: nil, priceL: 85, description: "白醇杏仁與小農鮮奶暖心融和。", isHotItem: true, cupStyle: .hotSpecialType),
        Drink(name: "白醇杏仁頂級可可", category: .hotSpecial, priceM: nil, priceL: 80, description: "杏仁香氣與頂級可可甜香。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "桂圓茶", category: .hotSpecial, priceM: 45, priceL: 55, description: "遵循古法熬煮柴燒桂圓茶。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "桂圓鮮奶茶", category: .hotSpecial, priceM: 65, priceL: 80, description: "桂圓甘甜結合濃郁鮮奶茶。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "薑薑好茶", category: .hotSpecial, priceM: 45, priceL: 55, description: "老薑母熬煮，驅寒暖身。", isHotItem: false, cupStyle: .hotSpecialType),
        Drink(name: "薑薑奶茶", category: .hotSpecial, priceM: 55, priceL: 70, description: "老薑微辣香與暖心奶茶。", isHotItem: false, cupStyle: .hotSpecialType),
        
        // --- 限定販售 ---
        Drink(name: "厚雪烏龍奶蓋", category: .limited, priceM: nil, priceL: 60, description: "鹹甜濃厚雪奶蓋覆蓋香醇烏龍茶。", isHotItem: true, cupStyle: .hiddenSpecial),
        Drink(name: "厚雪紅心芭樂奶蓋", category: .limited, priceM: nil, priceL: 80, description: "紅心芭樂果香與厚雪奶蓋。", isHotItem: false, cupStyle: .hiddenSpecial),
        Drink(name: "厚雪頂級可可奶蓋", category: .limited, priceM: nil, priceL: 80, description: "可可香與綿密厚雪奶蓋。", isHotItem: false, cupStyle: .hiddenSpecial),
        Drink(name: "益生菌纖維綠茶/紅茶", category: .limited, priceM: 60, priceL: 65, description: "添加膳食纖維與益生菌粉。", isHotItem: false, cupStyle: .greenTea),
        Drink(name: "益生菌纖維奶茶", category: .limited, priceM: 80, priceL: 90, description: "益生菌纖維融入香醇奶茶。", isHotItem: false, cupStyle: .bobaMilkTea),
        Drink(name: "珍珠巧克力艾思", category: .limited, priceM: nil, priceL: 75, description: "冰沙艾思搭配珍珠與巧克力冰淇淋。", isHotItem: true, cupStyle: .iceCreamType),
        Drink(name: "紅豆香草艾思", category: .limited, priceM: nil, priceL: 85, description: "蜜紅豆與香草冰淇淋艾思冰沙。", isHotItem: false, cupStyle: .iceCreamType),
        Drink(name: "鳳梨百香椰果艾思", category: .limited, priceM: nil, priceL: 85, description: "鳳梨百香果冰沙搭配椰果。", isHotItem: false, cupStyle: .iceCreamType),
        Drink(name: "黑糖珍珠仙草艾思", category: .limited, priceM: nil, priceL: 55, description: "黑糖珍珠與滑嫩仙草艾思。", isHotItem: false, cupStyle: .iceCreamType)
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
