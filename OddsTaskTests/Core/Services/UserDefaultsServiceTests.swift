//
//  UserDefaultsServiceTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import XCTest
@testable import OddsTask

final class UserDefaultsServiceTests: XCTestCase {
    
    private var userDefaultsService: UserDefaultsService!
    private var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a test suite name to avoid conflicts with real UserDefaults
        mockUserDefaults = UserDefaults(suiteName: "TestSuite")!
        userDefaultsService = UserDefaultsService(defaults: mockUserDefaults)
    }
    
    override func tearDown() {
        // Clean up test data
        userDefaultsService.removeAll()
        userDefaultsService = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_withUserDefaults_succeeds() {
        let service = UserDefaultsService(defaults: UserDefaults.standard)
        XCTAssertNotNil(service)
    }
    
    func test_initialization_storesUserDefaults() {
        XCTAssertTrue(userDefaultsService.userDefaults === mockUserDefaults)
    }
    
    // MARK: - Set/Get Value Tests
    
    func test_setValue_andGetValue_string() {
        let testValue = "test_string"
        let key = UserDefaultsService.Keys.themeMode
        
        userDefaultsService.set(data: testValue, forKey: key)
        let retrievedValue: String? = userDefaultsService.value(forKey: key)
        
        XCTAssertEqual(retrievedValue, testValue, "Retrieved value should match stored value")
        XCTAssertNotNil(retrievedValue, "Retrieved value should not be nil")
    }
    
    
    func test_getValue_nonExistentKey_returnsNil() {
        let retrievedValue: String? = userDefaultsService.value(forKey: .themeMode)
        XCTAssertNil(retrievedValue)
    }
    
    // MARK: - Codable Object Tests
    
    func test_setObject_andGetObject_codableStruct() {
        struct TestStruct: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let testObject = TestStruct(name: "Test", age: 25)
        let key = UserDefaultsService.Keys.themeMode
        
        userDefaultsService.setObject(data: testObject, forKey: key)
        let retrievedObject: TestStruct? = userDefaultsService.getObject(forKey: key)
        
        XCTAssertEqual(retrievedObject, testObject, "Retrieved object should match stored object")
        XCTAssertNotNil(retrievedObject, "Retrieved object should not be nil")
        XCTAssertEqual(retrievedObject?.name, "Test", "Object name should be preserved")
        XCTAssertEqual(retrievedObject?.age, 25, "Object age should be preserved")
    }
    
    
    func test_getObject_nonExistentKey_returnsNil() {
        let retrievedObject: [String]? = userDefaultsService.getObject(forKey: .themeMode)
        XCTAssertNil(retrievedObject)
    }
    
    
    // MARK: - Remove All Tests
    
    func test_removeAll_clearsAllData() {
        // Set multiple values
        userDefaultsService.set(data: "test1", forKey: .themeMode)
        
        // Verify data exists
        let value1: String? = userDefaultsService.value(forKey: .themeMode)
        XCTAssertNotNil(value1)
        
        // Remove all
        userDefaultsService.removeAll()
        
        // Verify data is removed
        let removedValue1: String? = userDefaultsService.value(forKey: .themeMode)
        XCTAssertNil(removedValue1)
    }
    
    
    // MARK: - Protocol Conformance Tests
    
    func test_conformsToUserDefaultsServiceProtocol() {
        let serviceAsProtocol: UserDefaultsServiceProtocol = userDefaultsService
        XCTAssertNotNil(serviceAsProtocol)
    }
    
    func test_protocolMethods_areImplemented() {
        let serviceProtocol: UserDefaultsServiceProtocol = userDefaultsService
        
        // Test all protocol methods are callable
        serviceProtocol.set(data: "test", forKey: .themeMode)
        let value: String? = serviceProtocol.value(forKey: .themeMode)
        serviceProtocol.setObject(data: ["test"], forKey: .themeMode)
        let object: [String]? = serviceProtocol.getObject(forKey: .themeMode)
        serviceProtocol.removeAll()
        
        XCTAssertNotNil(value)
        XCTAssertNotNil(object)
    }
}
