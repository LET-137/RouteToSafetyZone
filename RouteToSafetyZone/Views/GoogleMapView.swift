import SwiftUI
import GooglePlaces
import GoogleMaps

struct GoogleMapView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    @EnvironmentObject var locationManager: LocationManager
    @Binding var centerCoodinate: CLLocationCoordinate2D
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var zoom: Float = 12.0

//    マップのカメラを移動し終えた位置に、マップ画面を固定
    class Coodinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        
        init(parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let center = mapView.projection.coordinate(for: mapView.center)
            parent.centerCoodinate = center
        }
    }
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        viewController.view = mapView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let location = locationManager.userLocation else { return }
        let cameraUpdata = GMSCameraUpdate.setTarget(location, zoom: zoom)
        let mapView = GMSMapView()
        mapView.animate(with: cameraUpdata)
    }
    
    func addMarker(mapView: GMSMapView) -> GMSMarker {
        mapView.clear()
        let marker = GMSMarker()
        guard let location = locationManager.userLocation else { return marker }
        marker.position = location
        marker.title = "現在地"
        marker.map = mapView
        return marker
    }
}
