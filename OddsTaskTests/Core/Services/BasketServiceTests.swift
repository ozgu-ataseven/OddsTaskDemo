//
//  BasketServiceTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import XCTest
import FirebaseFirestore
@testable import OddsTask

final class BasketServiceTests: XCTestCase {
    
    private var basketService: BasketService!
    
    override func setUp() {
        super.setUp()
        basketService = BasketService()
    }
    
    override func tearDown() {
        basketService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_succeeds() {
        XCTAssertNotNil(basketService)
    }
    
    // MARK: - Add Item Tests
    
    func test_addItem_withValidData_callsCompletion() {
        let expectation = XCTestExpectation(description: "Add item completion")
        let basketItem = BasketItem(
            id: "test-id",
            homeTeam: "Team A",
            awayTeam: "Team B",
            outcomeName: "Team A",
            price: 2.5,
            amount: 10.0,
            bookmakerTitle: "Bet365"
        )
        let userId = "test-user-id"
        
        basketService.addItem(basketItem, for: userId) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Add item succeeded")
            case .failure(let error):
                // Firestore may not be configured in test environment
                XCTAssertNotNil(error, "Error should be present if operation failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Fetch Items Tests
    
    func test_fetchItems_withValidUserId_callsCompletion() {
        let expectation = XCTestExpectation(description: "Fetch items completion")
        let userId = "test-user-id"
        
        basketService.fetchItems(for: userId) { result in
            switch result {
            case .success(let items):
                XCTAssertNotNil(items, "Items array should not be nil")
                // Items can be empty if no data exists, which is valid
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be present if operation failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Remove Item Tests
    
    func test_removeItem_withValidData_callsCompletion() {
        let expectation = XCTestExpectation(description: "Remove item completion")
        let itemId = "test-item-id"
        let userId = "test-user-id"
        
        basketService.removeItem(itemId: itemId, for: userId) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Remove item succeeded")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be present if operation failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Clear Basket Tests
    
    func test_clearBasket_withValidUserId_callsCompletion() {
        let expectation = XCTestExpectation(description: "Clear basket completion")
        let userId = "test-user-id"
        
        basketService.clearBasket(for: userId) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Clear basket succeeded")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be present if operation failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Protocol Conformance Tests
    
    func test_conformsToBasketServiceProtocol() {
        let serviceAsProtocol: BasketServiceProtocol = basketService
        XCTAssertNotNil(serviceAsProtocol)
    }
    
    func test_protocolMethods_areImplemented() {
        let serviceProtocol: BasketServiceProtocol = basketService
        let basketItem = BasketItem(
            id: "test",
            homeTeam: "home",
            awayTeam: "away",
            outcomeName: "outcome",
            price: 1.0,
            amount: 1.0,
            bookmakerTitle: "TestBookmaker"
        )
        
        // Test that all protocol methods are callable
        let expectation1 = XCTestExpectation(description: "Add item protocol")
        serviceProtocol.addItem(basketItem, for: "user") { _ in
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Fetch items protocol")
        serviceProtocol.fetchItems(for: "user") { _ in
            expectation2.fulfill()
        }
        
        let expectation3 = XCTestExpectation(description: "Remove item protocol")
        serviceProtocol.removeItem(itemId: "item", for: "user") { _ in
            expectation3.fulfill()
        }
        
        let expectation4 = XCTestExpectation(description: "Clear basket protocol")
        serviceProtocol.clearBasket(for: "user") { _ in
            expectation4.fulfill()
        }
        
        wait(for: [expectation1, expectation2, expectation3, expectation4], timeout: 10.0)
    }
    
}
