//
//  RouteToSafetyZoneUITestsLaunchTests.swift
//  RouteToSafetyZoneUITests
//
//  Created by 津本拓也 on 2024/08/21.
//

import XCTest
@testable import RouteToSafetyZone


final class RouteToSafetyZoneUITestsLaunchTests: XCTestCase {
    var appDelegate: AppDelegate!
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
        appDelegate = AppDelegate()
    }
    
    override func tearDownWithError() throws {
        appDelegate = nil
        try super.tearDownWithError()
    }
    
//    アプリケーションの起動テスト
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        func testDidFinishLaunchingWithOptions() throws {
            let application = UIApplication.shared
            let launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
            
            let result = appDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
            XCTAssertTrue(result, "アプリケーションの起動に失敗しました")
        }
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
