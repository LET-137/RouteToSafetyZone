import Foundation
import SwiftUI
import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var location: CLLocation?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var status: CLAuthorizationStatus?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

//    位置情報の更新時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
            self.userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
//    権限の変更時に呼ばれる
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.status = manager.authorizationStatus
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        }
    }
}
