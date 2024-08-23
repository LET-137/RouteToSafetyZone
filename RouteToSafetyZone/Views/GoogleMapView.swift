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
    
    //    GMSMapViewDelegate
    class Coodinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        
        init(parent: GoogleMapView) {
            self.parent = parent
        }
        //    マップのカメラを移動し終えた位置に、マップ画面を固定
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let center = mapView.projection.coordinate(for: mapView.center)
            parent.centerCoodinate = center
        }
        //        マップをタップした時にピンを打つ
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            mapView.clear()
            let marker = GMSMarker(position: coordinate)
            marker.title = "目的地"
            marker.appearAnimation = .fadeIn
            marker.map = mapView
        }
    }
    
    func makeCoordinator() -> Coodinator {
        return Coodinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.delegate = context.coordinator
        viewController.view = mapView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let location = locationManager.userLocation else { return }
        let cameraUpdata = GMSCameraUpdate.setTarget(location, zoom: zoom)
        let mapView = GMSMapView()
        mapView.animate(with: cameraUpdata)
    }
}
