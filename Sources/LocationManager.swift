import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var isLocating: Bool = false
    @Published var lastLocatedAddress: String = ""
    @Published var lastLocatedDistrict: String = ""
    @Published var locationError: String? = nil
    
    private var locationCallback: ((String, String) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func fetchCurrentLocation(completion: @escaping (String, String) -> Void) {
        self.locationCallback = completion
        self.isLocating = true
        self.locationError = nil
        
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.isLocating = false
            self.locationError = "請在手機「設定」中允許清心福全取用位置權限以啟用自動定位"
            // Fallback default
            completion("中西區", "台南市中西區西門路二段100號")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        @unknown default:
            manager.requestLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if isLocating {
                manager.requestLocation()
            }
        } else if status == .denied || status == .restricted {
            if isLocating {
                isLocating = false
                locationError = "定位權限遭拒絕"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            isLocating = false
            return
        }
        
        let locale = Locale(identifier: "zh_TW")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLocating = false
                
                if let error = error {
                    self.locationError = "反向地址解析失敗: \(error.localizedDescription)"
                    self.locationCallback?("中西區", "台南市中西區西門路二段100號")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    self.locationCallback?("中西區", "台南市中西區西門路二段100號")
                    return
                }
                
                let city = placemark.administrativeArea ?? ""
                let district = placemark.subAdministrativeArea ?? placemark.locality ?? ""
                let street = placemark.thoroughfare ?? ""
                let subThoroughfare = placemark.subThoroughfare ?? ""
                
                var fullAddress = ""
                if !city.isEmpty { fullAddress += city }
                if !district.isEmpty && !fullAddress.contains(district) { fullAddress += district }
                if !street.isEmpty { fullAddress += street }
                if !subThoroughfare.isEmpty { fullAddress += subThoroughfare }
                
                if fullAddress.isEmpty {
                    fullAddress = placemark.name ?? "目前位置"
                }
                
                self.lastLocatedAddress = fullAddress
                self.lastLocatedDistrict = district.isEmpty ? "市區" : district
                self.locationCallback?(self.lastLocatedDistrict, self.lastLocatedAddress)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLocating = false
            self.locationError = "定位失敗，請確認已開啟 GPS 定位服務"
            // Provide gentle fallback
            self.locationCallback?("中西區", "台南市中西區西門路二段100號")
        }
    }
}
