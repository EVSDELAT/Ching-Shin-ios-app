import Foundation

struct MockData {
    static let sampleDrinks: [Drink] = [
        // 隱藏特調 / 熱門
        Drink(
            id: "d1",
            name: "隱藏版 (珍珠椰果奶綠)",
            englishName: "Secret Blend (Milk Green Tea w/ Boba & Coconut)",
            basePrice: 65,
            category: .hiddenSecret,
            description: "清心傳奇熱銷款！高山綠茶融入濃香奶味，搭配Q彈珍珠與甜脆椰果，雙重口感一次滿足。",
            calories: 420,
            imageEmoji: "🧋",
            isPopular: true,
            isHotAvailable: true,
            defaultSugar: .micro,
            defaultIce: .lessIce,
            teaTypeColor: "milkTea"
        ),
        Drink(
            id: "d2",
            name: "烏龍綠茶",
            englishName: "Oolong Green Tea",
            basePrice: 35,
            category: .pureTea,
            description: "清心福全經典鎮店之寶！嚴選高山烏龍與清新綠茶黃金比例調和，甘醇生津、餘韻悠長。",
            calories: 120,
            imageEmoji: "🍵",
            isPopular: true,
            isHotAvailable: true,
            defaultSugar: .micro,
            defaultIce: .microIce,
            teaTypeColor: "oolong"
        ),
        Drink(
            id: "d3",
            name: "優多綠茶",
            englishName: "Yaku Green Tea",
            basePrice: 55,
            category: .fruitTea,
            description: "特選特級養樂多與清新特級綠茶完美結合，甜酸爽口，解膩助消化。",
            calories: 280,
            imageEmoji: "🍹",
            isPopular: true,
            isHotAvailable: false,
            defaultSugar: .micro,
            defaultIce: .lessIce,
            teaTypeColor: "fruit"
        ),
        Drink(
            id: "d4",
            name: "珍珠奶茶",
            englishName: "Boba Milk Tea",
            basePrice: 55,
            category: .milkTea,
            description: "古早味經典奶茶搭配當日現煮Q彈黑糖波霸珍珠，濃郁滑順！",
            calories: 460,
            imageEmoji: "🧋",
            isPopular: true,
            isHotAvailable: true,
            defaultSugar: .half,
            defaultIce: .lessIce,
            teaTypeColor: "milkTea"
        ),
        Drink(
            id: "d5",
            name: "翡翠烏龍",
            englishName: "Jade Oolong Tea",
            basePrice: 40,
            category: .pureTea,
            description: "高海拔冷冽茶園手採嫩葉，茶湯色澤如翡翠清澈，入甘轉甜。",
            calories: 110,
            imageEmoji: "🍃",
            isPopular: true,
            isHotAvailable: true,
            defaultSugar: .sugarFree,
            defaultIce: .microIce,
            teaTypeColor: "green"
        ),
        Drink(
            id: "d6",
            name: "葡萄柚綠茶",
            englishName: "Grapefruit Green Tea",
            basePrice: 60,
            category: .fruitTea,
            description: "新鮮葡萄柚果肉搭配茉莉香綠茶，酸甜果香與清爽茶香交織。",
            calories: 210,
            imageEmoji: "🍊",
            isPopular: false,
            isHotAvailable: false,
            defaultSugar: .micro,
            defaultIce: .lessIce,
            teaTypeColor: "fruit"
        ),
        Drink(
            id: "d7",
            name: "錫蘭鮮奶茶",
            englishName: "Ceylon Fresh Milk Tea",
            basePrice: 65,
            category: .milkTea,
            description: "嚴選斯里蘭卡高山錫蘭紅茶，加入100%優質鮮乳，醇厚乳香再升級。",
            calories: 310,
            imageEmoji: "🥛",
            isPopular: true,
            isHotAvailable: true,
            defaultSugar: .micro,
            defaultIce: .microIce,
            teaTypeColor: "milkTea"
        ),
        Drink(
            id: "d8",
            name: "冬瓜檸檬",
            englishName: "Winter Melon Lemon",
            basePrice: 50,
            category: .slushWinterMelon,
            description: "古法熬製台南手工冬瓜磚，融入屏東現榨鮮檸檬汁，甜酸怡人。",
            calories: 260,
            imageEmoji: "🍋",
            isPopular: false,
            isHotAvailable: true,
            defaultSugar: .micro,
            defaultIce: .lessIce,
            teaTypeColor: "winterMelon"
        ),
        Drink(
            id: "d9",
            name: "綠茶冰沙",
            englishName: "Green Tea Slush",
            basePrice: 55,
            category: .slushWinterMelon,
            description: "夏日消暑首選！將濃郁綠茶細緻打成微細冰粒，沁涼透心。",
            calories: 230,
            imageEmoji: "🍧",
            isPopular: false,
            isHotAvailable: false,
            defaultSugar: .half,
            defaultIce: .regularIce,
            teaTypeColor: "slush"
        ),
        Drink(
            id: "d10",
            name: "仙草凍奶茶",
            englishName: "Grass Jelly Milk Tea",
            basePrice: 60,
            category: .milkTea,
            description: "滑嫩關西仙草凍沉浸於經典奶茶中，入口即化，清涼解渴。",
            calories: 380,
            imageEmoji: "🍮",
            isPopular: false,
            isHotAvailable: true,
            defaultSugar: .micro,
            defaultIce: .lessIce,
            teaTypeColor: "milkTea"
        )
    ]
    
    static let sampleStores: [Store] = [
        Store(id: "s1", name: "清心福全 台北信義店", address: "台北市信義區忠孝東路五段168號", phone: "(02) 2723-8899", businessHours: "09:30 - 22:00", distanceKm: 0.3, isFavorite: true, isOpen: true),
        Store(id: "s2", name: "清心福全 台南總店", address: "台南市中西區西門路二段222號", phone: "(06) 221-5566", businessHours: "09:00 - 22:30", distanceKm: 1.2, isFavorite: false, isOpen: true),
        Store(id: "s3", name: "清心福全 台中一中店", address: "台中市北區三民路三段120號", phone: "(04) 2225-3377", businessHours: "10:00 - 23:00", distanceKm: 2.5, isFavorite: false, isOpen: true),
        Store(id: "s4", name: "清心福全 高雄三多店", address: "高雄市苓雅區三多三路210號", phone: "(07) 338-9911", businessHours: "09:30 - 21:30", distanceKm: 3.8, isFavorite: false, isOpen: true)
    ]
    
    static let sampleCoupons: [Coupon] = [
        Coupon(id: "c1", title: "🎉 老闆招待折價券", discountText: "滿 $100 現折 $20", discountAmount: 20, minSpend: 100, validUntil: "2026/12/31", code: "BOSS20", isUsed: false),
        Coupon(id: "c2", title: "🧋 新品隱藏版專屬", discountText: "隱藏版系列折 $10", discountAmount: 10, minSpend: 65, validUntil: "2026/11/15", code: "SECRET10", isUsed: false),
        Coupon(id: "c3", title: "🍃 週五好茶日", discountText: "純茶系列現折 $5", discountAmount: 5, minSpend: 35, validUntil: "2026/10/31", code: "TEA5", isUsed: false)
    ]
}
