import SwiftUI

struct StoreLocatorView: View {
    @Binding var selectedStore: Store
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchStoreText: String = ""
    
    var filteredStores: [Store] {
        SampleData.sampleStores.filter { store in
            searchStoreText.isEmpty || store.name.contains(searchStoreText) || store.address.contains(searchStoreText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Store
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜尋門市名稱或地址...", text: $searchStoreText)
                        .font(.subheadline)
                }
                .padding(12)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding()
                
                // Store List
                List(filteredStores) { store in
                    Button(action: {
                        selectedStore = store
                        dismiss()
                    }) {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(store.id == selectedStore.id ? Color(hex: "008B47") : Color.gray.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: store.id == selectedStore.id ? "checkmark" : "mappin.and.ellipse")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(store.id == selectedStore.id ? .white : Color(hex: "008B47"))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(store.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text(store.distance)
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(Color(hex: "008B47"))
                                }
                                
                                Text(store.address)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 12) {
                                    HStack(spacing: 4) {
                                        Circle().fill(Color.green).frame(width: 6, height: 6)
                                        Text("營業中 (\(store.operatingHours))")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                    }
                                    
                                    Text("電話: \(store.phone)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 2)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("選擇清心福全門市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("關閉") { dismiss() }
                }
            }
        }
    }
}
