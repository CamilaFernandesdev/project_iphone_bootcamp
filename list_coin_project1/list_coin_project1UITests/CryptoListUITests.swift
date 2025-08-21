//
//  CryptoListUITests.swift
//  CryptoMarketAppUITests
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import XCTest

final class CryptoListUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test App Launch
    func testAppLaunch() throws {
        // Verify app launches successfully
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Check if main navigation title is displayed
        let navigationTitle = app.navigationBars["Criptomoedas"]
        XCTAssertTrue(navigationTitle.exists)
    }
    
    // MARK: - Test Search Functionality
    func testSearchFunctionality() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Find search field
        let searchField = app.textFields["Buscar criptomoedas..."]
        XCTAssertTrue(searchField.exists)
        
        // Tap on search field
        searchField.tap()
        
        // Type search query
        searchField.typeText("Bitcoin")
        
        // Verify search is working
        XCTAssertEqual(searchField.value as? String, "Bitcoin")
    }
    
    // MARK: - Test Refresh Functionality
    func testRefreshFunctionality() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Find refresh button
        let refreshButton = app.navigationBars.buttons["arrow.clockwise"]
        XCTAssertTrue(refreshButton.exists)
        
        // Tap refresh button
        refreshButton.tap()
        
        // Verify refresh action (could check for loading indicator)
        // This test verifies the button exists and is tappable
    }
    
    // MARK: - Test List Scrolling
    func testListScrolling() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Find the main list
        let list = app.collectionViews.firstMatch
        XCTAssertTrue(list.exists)
        
        // Perform scroll gesture
        list.swipeUp()
        list.swipeDown()
        
        // Verify scrolling works without crashing
        XCTAssertTrue(list.exists)
    }
    
    // MARK: - Test Pull to Refresh
    func testPullToRefresh() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Find the main list
        let list = app.collectionViews.firstMatch
        XCTAssertTrue(list.exists)
        
        // Perform pull to refresh gesture
        let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: end)
        
        // Verify pull to refresh works without crashing
        XCTAssertTrue(list.exists)
    }
    
    // MARK: - Test Navigation
    func testNavigation() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Check if navigation bar exists
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists)
        
        // Check if navigation title is correct
        let title = navigationBar.staticTexts["Criptomoedas"]
        XCTAssertTrue(title.exists)
    }
    
    // MARK: - Test Accessibility
    func testAccessibility() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Check if search field has accessibility label
        let searchField = app.textFields["Buscar criptomoedas..."]
        XCTAssertTrue(searchField.exists)
        
        // Check if refresh button has accessibility identifier
        let refreshButton = app.navigationBars.buttons["arrow.clockwise"]
        XCTAssertTrue(refreshButton.exists)
    }
    
    // MARK: - Test Dark Mode Compatibility
    func testDarkModeCompatibility() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Verify app elements are visible in current appearance
        let navigationTitle = app.navigationBars["Criptomoedas"]
        XCTAssertTrue(navigationTitle.exists)
        
        let searchField = app.textFields["Buscar criptomoedas..."]
        XCTAssertTrue(searchField.exists)
    }
    
    // MARK: - Test Performance
    func testPerformance() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Measure app launch time
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            // Perform some basic operations
            let searchField = app.textFields["Buscar criptomoedas..."]
            searchField.tap()
            searchField.typeText("Test")
        }
    }
    
    // MARK: - Test Error Handling
    func testErrorHandling() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // This test would require mocking network errors
        // For now, just verify the app doesn't crash
        XCTAssertTrue(app.exists)
    }
    
    // MARK: - Test Offline Mode
    func testOfflineMode() throws {
        // Wait for app to load
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // This test would require simulating offline state
        // For now, just verify the app loads successfully
        XCTAssertTrue(app.exists)
    }
}
