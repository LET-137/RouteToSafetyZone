import SwiftUI
import GooglePlaces
import GoogleMaps
import CoreLocation

@main
struct RouteToSafetyZoneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate, CLLocationManagerDelegate {
    @StateObject var locationManager = LocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSPlacesClient.provideAPIKey(googleMapAPIKey)
        GMSServices.provideAPIKey(googleMapAPIKey)
        return true
    }
}

