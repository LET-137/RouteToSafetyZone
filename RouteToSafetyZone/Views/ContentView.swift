import SwiftUI
import GoogleMaps

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State var locationUpdataManager = CLLocationManager()
//    @State var location: CLLocation
    
    var body: some View {
        if let location = locationManager.location {
            
            GoogleMapView(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
                .edgesIgnoringSafeArea(.all)
          
            
            Text("緯度: \(location.coordinate.latitude)")
            Text("軽度: \(location.coordinate.longitude)")
        } else {
            Text("現在値を取得中")
        }
        Button("更新") {
            locationUpdataManager.startUpdatingLocation()
        }
        
    }
        
}
