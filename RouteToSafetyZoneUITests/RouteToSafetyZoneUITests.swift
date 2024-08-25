//
//  RouteToSafetyZoneUITests.swift
//  RouteToSafetyZoneUITests
//
//  Created by 津本拓也 on 2024/08/21.
//
import SwiftUI
import XCTest
import CoreLocation
import GooglePlaces
import GoogleMaps
@testable import RouteToSafetyZone


final class RouteToSafetyZoneUITests: XCTestCase {
    var dummyLocation = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125) //  ダミーの位置情報をdummyLocationに格納（東京駅を指定）
    var googleMapView: GoogleMapView!
    var coordinator: GoogleMapView.Coodinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        GMSPlacesClient.provideAPIKey(googleMapAPIKey)
        GMSServices.provideAPIKey(googleMapAPIKey)
//        dummyLocationをBindingにコンバート
        let bindingLocation = Binding(
            get: { self.dummyLocation },
            set: { self.dummyLocation = $0 }
        )
        
        googleMapView = GoogleMapView(centerCoodinate: bindingLocation, latitude: dummyLocation.latitude, longitude: dummyLocation.longitude)
        coordinator = GoogleMapView.Coodinator(parent: googleMapView)
        
        let app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        coordinator = nil
        googleMapView = nil
        try super.tearDownWithError()
    }
    
//    マップのカメラ固定テスト
    func testMapViewCamera() throws {
       let mapView = GMSMapView()
       let camera = GMSCameraPosition(latitude: dummyLocation.latitude, longitude: dummyLocation.longitude, zoom: 15.0)
       coordinator.mapView(mapView, idleAt: camera)
       XCTAssertEqual(coordinator.parent.centerCoodinate.latitude, dummyLocation.latitude)
       XCTAssertEqual(coordinator.parent.centerCoodinate.longitude, dummyLocation.longitude)
   }
   
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
