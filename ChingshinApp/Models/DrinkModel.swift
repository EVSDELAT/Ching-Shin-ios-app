import Foundation
import SwiftUI

// MARK: - Category
enum DrinkCategory: String, CaseIterable, Identifiable, Codable {
    case popular = "🌟 熱門推薦"
    case pureTea = "🍃 嚴選好茶"
    case milkTea = "🧋 奶茶/鮮奶茶"
    case hiddenSecret = "✨ 隱藏版/特調"
    case fruitTea = "🍹 鮮果/優多"
    case slushWinterMelon = "🧊 冰沙/冬瓜"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .popular: return "star.fill"
        case .pureTea: return "leaf.fill"
        case .milkTea: return "cup.and.saucer.fill"
        case .hiddenSecret: return "sparkles"
        case .fruitTea: return "carrot.fill"
        case .slushWinterMelon: return "snowflake"
        }
    }
}

// MARK: - Sugar & Ice Options
enum SugarLevel: String, CaseIterable, Identifiable, Codable {
    case regular = "正常甜 (100%)"
    case less = "少甜 (70%)"
    case half = "半甜 (50%)"
    case micro = "微甜 (30%)"
    case oneTenth = "一分甜 (10%)"
    case sugarFree = "無甜 (0%)"
    
    var id: String { rawValue }
    
    var shortName: String {
        switch self {
        case .regular: return "正常甜"
        case .less: return "少甜"
        case .half: return "半甜"
        case .micro: return "微甜"
        case .oneTenth: return "一分甜"
        case .sugarFree: return "無甜"
        }
    }
}

enum IceLevel: String, CaseIterable, Identifiable, Codable {
    case regularIce = "正常冰"
    case lessIce = "少冰"
    case microIce = "微冰"
    case noIce = "去冰"
    case roomTemp = "常溫"
    case hot = "熱飲 ☕️"
    
    var id: String { rawValue }
    
    var isHot: Bool {
        self == .hot
    }
}

enum DrinkSize: String, CaseIterable, Identifiable, Codable {
    case medium = "中杯 (M)"
    case large = "大杯 (L)"
    
    var id: String { rawValue }
    
    var extraPrice: Int {
        switch self {
        case .medium: return 0
        case .large: return 10
        }
    }
}

struct Topping: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let price: Int
    
    static let allToppings: [Topping] = [
        Topping(id: "boba", name: "珍珠/波霸", price: 10),
        Topping(id: "coconut", name: "椰果", price: 10),
        Topping(id: "grassJelly", name: "仙草凍", price: 10),
        Topping(id: "pudding", name: "統一布丁", price: 15),
        Topping(id: "riceNoodle", name: "粉條", price: 10),
        Topping(id: "aiYu", name: "愛玉凍", price: 10)
    ]
}

// MARK: - Drink Model
struct Drink: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let englishName: String
    let basePrice: Int
    let category: DrinkCategory
    let description: String
    let calories: Int
    let imageEmoji: String
    let isPopular: Bool
    let isHotAvailable: Bool
    let defaultSugar: SugarLevel
    let defaultIce: IceLevel
    let teaTypeColor: String // for cup visualization
}

// MARK: - Cart Item
struct CartItem: Identifiable, Hashable, Codable {
    var id = UUID()
    let drink: Drink
    var size: DrinkSize
    var sugar: SugarLevel
    var ice: IceLevel
    var toppings: Set<Topping>
    var note: String
    var quantity: Int
    
    var unitPrice: Int {
        let toppingTotal = toppings.reduce(0) { $0 + $1.price }
        return drink.basePrice + size.extraPrice + toppingTotal
    }
    
    var totalPrice: Int {
        unitPrice * quantity
    }
}

// MARK: - Store Model
struct Store: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let address: String
    let phone: String
    let businessHours: String
    let distanceKm: Double
    var isFavorite: Bool
    let isOpen: Bool
}

// MARK: - Coupon Model
struct Coupon: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let discountText: String
    let discountAmount: Int
    let minSpend: Int
    let validUntil: String
    let code: String
    var isUsed: Bool
}

// MARK: - Order Status & History
enum OrderStatus: String, CaseIterable, Codable {
    case received = "已收到訂單"
    case preparing = "飲料調製中 🧋"
    case sealing = "封口檢驗中"
    case ready = "請至門市取餐 🟢"
    case completed = "訂單已完成 ✨"
    
    var stepIndex: Int {
        switch self {
        case .received: return 1
        case .preparing: return 2
        case .sealing: return 3
        case .ready: return 4
        case .completed: return 5
        }
    }
}

struct Order: Identifiable, Codable {
    let id: String
    let orderNumber: String
    let storeName: String
    let items: [CartItem]
    let totalPrice: Int
    let orderTime: Date
    var status: OrderStatus
    let isDelivery: Bool
    let deliveryAddress: String?
}
