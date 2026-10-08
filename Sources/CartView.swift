import SwiftUI

struct CartView: View {
    @Binding var cartItems: [CartItem]
    let orderMode: OrderMode
    let deliveryInfo: DeliveryInfo
    var onCheckout: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var subtotal: Int {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var discount: Int {
        subtotal >= 200 ? 20 : 0
    }
    
    var deliveryFee: Int {
        orderMode == .delivery ? deliveryInfo.calculateDeliveryFee(subtotal: subtotal) : 0
    }
    
    var finalTotal: Int {
        max(0, subtotal - discount + deliveryFee)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if cartItems.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "cart.badge.minus")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("購物車是空的")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("快去挑選幾杯清心福全招牌手搖飲吧！")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("點餐模式: \(orderMode.rawValue)")) {
                            if orderMode == .delivery {
                                HStack {
                                    Image(systemName: "bicycle")
                                        .foregroundColor(Color(hex: "008B47"))
                                    VStack(alignment: .leading) {
                                        Text("外送地址: \(deliveryInfo.address)")
                                            .font(.caption)
                                            .bold()
                                        Text("聯絡電話: \(deliveryInfo.phone) (備註: \(deliveryInfo.notes))")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            } else {
                                HStack {
                                    Image(systemName: "bag.fill")
                                        .foregroundColor(Color(hex: "008B47"))
                                    Text("外帶自取 ‧ 到店取餐")
                                        .font(.caption)
                                        .bold()
                                }
                            }
                        }
                        
                        Section(header: Text("已點飲料明細 (\(cartItems.count)項)")) {
                            ForEach(cartItems) { item in
                                HStack(alignment: .top, spacing: 12) {
                                    Drink3DThumbnailView(style: item.drink.cupStyle, size: 45)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.drink.name)
                                            .font(.headline)
                                        
                                        Text(item.customizationSummary)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Text("NT$ \(item.unitPrice) / 杯")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(Color(hex: "008B47"))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 6) {
                                        Text("NT$ \(item.totalPrice)")
                                            .font(.subheadline)
                                            .bold()
                                        
                                        Text("x\(item.quantity)")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                cartItems.remove(atOffsets: indexSet)
                            }
                        }
                        
                        Section(header: Text("金額試算明細")) {
                            HStack {
                                Text("小計")
                                Spacer()
                                Text("NT$ \(subtotal)")
                            }
                            
                            if discount > 0 {
                                HStack {
                                    HStack(spacing: 4) {
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(.red)
                                        Text("滿 200 折 20 優惠")
                                    }
                                    Spacer()
                                    Text("- NT$ \(discount)")
                                        .foregroundColor(.red)
                                        .bold()
                                }
                            }
                            
                            if orderMode == .delivery {
                                HStack {
                                    Text("外送服務費 (滿$150免運)")
                                    Spacer()
                                    Text(deliveryFee == 0 ? "免運費" : "+ NT$ \(deliveryFee)")
                                        .foregroundColor(deliveryFee == 0 ? Color(hex: "008B47") : .orange)
                                        .bold()
                                }
                            }
                            
                            HStack {
                                Text("應付總金額")
                                    .font(.headline)
                                Spacer()
                                Text("NT$ \(finalTotal)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(hex: "008B47"))
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("購物車與點餐明細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("關閉") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !cartItems.isEmpty {
                    Button(action: {
                        dismiss()
                        onCheckout()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("確認點餐 ‧ 送出訂單")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("NT$ \(finalTotal)")
                                .font(.title3)
                                .bold()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "008B47"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(hex: "008B47").opacity(0.3), radius: 6, x: 0, y: 3)
                        .padding()
                    }
                    .background(.ultraThinMaterial)
                }
            }
        }
    }
}
