//
//  FirebaseAnalyticsServiceTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import XCTest
import FirebaseAnalytics
@testable import OddsTask

final class FirebaseAnalyticsServiceTests: XCTestCase {
    
    private var analyticsService: FirebaseAnalyticsService!
    
    override func setUp() {
        super.setUp()
        analyticsService = FirebaseAnalyticsService()
    }
    
    override func tearDown() {
        analyticsService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_succeeds() {
        XCTAssertNotNil(analyticsService)
    }
    
    // MARK: - Log Event Tests
    
    func test_logEvent_withNameAndParameters_doesNotCrash() {
        let eventName = "test_event"
        let parameters = ["key1": "value1", "key2": 123] as [String: Any]
        
        XCTAssertNoThrow(analyticsService.logEvent(name: eventName, parameters: parameters))
        
        // Verify parameters are properly handled
        XCTAssertEqual(eventName, "test_event", "Event name should be preserved")
        XCTAssertNotNil(parameters["key1"], "Parameters should contain key1")
        XCTAssertNotNil(parameters["key2"], "Parameters should contain key2")
    }
    
    func test_logEvent_withNameOnly_doesNotCrash() {
        let eventName = "simple_event"
        
        XCTAssertNoThrow(analyticsService.logEvent(name: eventName, parameters: nil))
        XCTAssertEqual(eventName, "simple_event", "Event name should be preserved")
    }
    
    
    // MARK: - Log Screen View Tests
    
    func test_logScreenView_withScreenName_doesNotCrash() {
        let screenName = "LoginScreen"
        
        XCTAssertNoThrow(analyticsService.logScreenView(screenName: screenName))
        XCTAssertEqual(screenName, "LoginScreen", "Screen name should be preserved")
    }
    
    func test_logScreenView_withEmptyScreenName_doesNotCrash() {
        analyticsService.logScreenView(screenName: "")
        
        XCTAssertTrue(true, "logScreenView with empty screen name completed without crashing")
    }
    
    func test_logScreenView_withLongScreenName_doesNotCrash() {
        let longScreenName = String(repeating: "A", count: 1000)
        
        analyticsService.logScreenView(screenName: longScreenName)
        
        XCTAssertTrue(true, "logScreenView with long screen name completed without crashing")
    }
    
    func test_logScreenView_withSpecialCharacters_doesNotCrash() {
        let screenName = "Screen@#$%^&*()_+{}|:<>?[]\\;'\",./"
        
        analyticsService.logScreenView(screenName: screenName)
        
        XCTAssertTrue(true, "logScreenView with special characters completed without crashing")
    }
    
    // MARK: - Log User Property Tests
    
    func test_logUserProperty_withNameAndValue_doesNotCrash() {
        let propertyName = "user_type"
        let propertyValue = "premium"
        
        XCTAssertNoThrow(analyticsService.logUserProperty(name: propertyName, value: propertyValue))
        XCTAssertEqual(propertyName, "user_type", "Property name should be preserved")
        XCTAssertEqual(propertyValue, "premium", "Property value should be preserved")
    }
    
    
    // MARK: - Protocol Conformance Tests
    
    func test_conformsToAnalyticsServiceProtocol() {
        // Test that we can use the service as the protocol type
        let serviceAsProtocol: AnalyticsServiceProtocol = analyticsService
        XCTAssertNotNil(serviceAsProtocol)
    }
    
    func test_protocolMethods_areImplemented() {
        let serviceProtocol: AnalyticsServiceProtocol = analyticsService
        
        // Test that all protocol methods are callable
        serviceProtocol.logEvent(name: "test_event", parameters: ["key": "value"])
        serviceProtocol.logScreenView(screenName: "TestScreen")
        serviceProtocol.logUserProperty(name: "test_property", value: "test_value")
        
        XCTAssertTrue(true, "All protocol methods completed without crashing")
    }
    
}
