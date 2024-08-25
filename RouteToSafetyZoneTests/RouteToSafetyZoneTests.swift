//
//  RouteToSafetyZoneTests.swift
//  RouteToSafetyZoneTests
//
//  Created by 津本拓也 on 2024/08/21.
//

import XCTest
import CoreLocation
@testable import RouteToSafetyZone

final class RouteToSafetyZoneTests: XCTestCase {
    private var locationManager: CLLocationManagerDelegate!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        locationManager = LocationManager()
    }
    
    override func tearDownWithError() throws {
        locationManager = nil
        try super.tearDownWithError()
    }
    
    //    位置情報の許可を設定するモック
    class MockCLLocationManager: CLLocationManager {
        //        位置情報取得を許可しないように設定
        var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
        override var authorizationStatus: CLAuthorizationStatus {
            return mockAuthorizationStatus
        }
    }
    
    //    MockCLLocatinoManagerを使用して、位置情報許可の更新をテスト
    func testLocationManagerDidChangeAuthorization() {
        let mockCLLocationManager = MockCLLocationManager()
        //      フォアグラウンド時に位置情報を許可に設定
        mockCLLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
        let locationManager = LocationManager(locationManager: mockCLLocationManager)
        
        //      locationManagerDidChangeAuthorizationがauthorizedWhenInUseを返すか？
        locationManager.locationManagerDidChangeAuthorization(mockCLLocationManager)
        XCTAssertEqual(locationManager.status, .authorizedWhenInUse)
    }
    
    //    位置情報テスト
    func testLocationManager() {
        let mockLocationManager = MockCLLocationManager()
        let locationManager = LocationManager(locationManager: mockLocationManager)
        
        let expectation = XCTestExpectation(description: "位置情報を更新させる")
        let dummyLocation = CLLocation(latitude: 35.681236, longitude: 139.767125) //  ダミーの位置情報を格納（東京駅を指定）
        //      dummyLocationの位置情報を返すかテスト
        locationManager.locationManager(mockLocationManager, didUpdateLocations: [dummyLocation])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(locationManager.location?.coordinate.latitude, dummyLocation.coordinate.latitude)
            XCTAssertEqual(locationManager.location?.coordinate.longitude, dummyLocation.coordinate.longitude)
            
            XCTAssertEqual(locationManager.userLocation?.latitude, dummyLocation.coordinate.latitude)
            XCTAssertEqual(locationManager.userLocation?.longitude, dummyLocation.coordinate.longitude)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func testExample() throws {
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
