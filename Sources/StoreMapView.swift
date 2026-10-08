import SwiftUI
import MapKit

struct StoreMapSheet: View {
    let store: Store
    @Environment(\.dismiss) private var dismiss
    
    @State private var region: MKCoordinateRegion
    
    init(store: Store) {
        self.store = store
        // Approximate coordinates for Tainan stores
        let center = CLLocationCoordinate2D(latitude: 22.9997, longitude: 120.2025)
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: [store]) { storeLocation in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.9997, longitude: 120.2025)) {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "008B47"))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Text(storeLocation.name)
                                .font(.system(size: 11, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.white)
                                .foregroundColor(Color(hex: "1F2937"))
                                .clipShape(Capsule())
                                .shadow(radius: 2)
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Store Info Card & Navigation Button
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "008B47").opacity(0.15))
                                .frame(width: 44, height: 44)
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "008B47"))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "1F2937"))
                            Text(store.address)
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "6B7280"))
                            Text("電話: \(store.phone) ‧ 營業時間: \(store.operatingHours)")
                                .font(.system(size: 11))
                                .foregroundColor(Color(hex: "9CA3AF"))
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        SoundManager.shared.playTapSound()
                        let encodedAddress = store.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "https://maps.apple.com/?q=\(encodedAddress)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            Text("開啟 Apple Maps 路線導航")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "008B47"))
                        .clipShape(Capsule())
                    }
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle("門市地圖位置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "008B47"))
                }
            }
        }
    }
}
