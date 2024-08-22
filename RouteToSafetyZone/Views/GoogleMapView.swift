import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var zoom: Float
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView()
        mapView.camera = camera
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        uiView.camera = camera
    }
}

