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
        let mapView = GMSMapView()
    }
    
    //    DirectionAPIリクエストのURLを生成
    func fetchDirectionURL(destination: CLLocationCoordinate2D) async throws -> String {
        if let originLatitube = locationManager.location?.coordinate.latitude,
           let originLongitube = locationManager.location?.coordinate.longitude {
            let originString = CLLocation(latitude: originLatitube, longitude: originLongitube)
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destination)&$mode=driving$key=\(googleMapAPIKey)"
            return urlString
        }
        return ""
    }
    
    //    GMSPathを取得する
    func fetchDirectionPath(url: String) async throws -> GMSPath?{
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let routes = json["routes"] as? [[String: Any]],
           let overview_polyline = routes.first?["overview_polyline"] as? [String: Any],
           let points = overview_polyline["points"] as? String {
            
            if let path = GMSPath(fromEncodedPath: points){
                return path
            }
            return nil
        }
        return nil
    }    
}
