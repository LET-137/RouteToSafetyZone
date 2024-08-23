import SwiftUI
import GooglePlaces
import GoogleMaps

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var centerCoodinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    var body: some View {
        if let location = locationManager.location {
            
            GoogleMapView(centerCoodinate: $centerCoodinate, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
                .edgesIgnoringSafeArea(.all)
          
            Text("緯度: \(location.coordinate.latitude)")
            Text("軽度: \(location.coordinate.longitude)")
        } else {
            Text("現在値を取得中")
        }
    }
        
}
