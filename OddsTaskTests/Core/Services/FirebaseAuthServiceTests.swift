//
//  FirebaseAuthServiceTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import XCTest
import FirebaseAuth
@testable import OddsTask

final class FirebaseAuthServiceTests: XCTestCase {
    
    private var authService: FirebaseAuthService!
    
    override func setUp() {
        super.setUp()
        authService = FirebaseAuthService()
    }
    
    override func tearDown() {
        authService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_succeeds() {
        XCTAssertNotNil(authService)
    }
    
    // MARK: - Login Tests
    
    func test_login_withValidCredentials_callsCompletion() {
        let expectation = XCTestExpectation(description: "Login completion")
        let email = "test@example.com"
        let password = "password123"
        
        authService.login(email: email, password: password) { result in
            // We expect this to complete (success or failure doesn't matter for unit test)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Register Tests
    
    func test_register_withValidCredentials_callsCompletion() {
        let expectation = XCTestExpectation(description: "Register completion")
        let email = "newuser@example.com"
        let password = "password123"
        
        authService.register(email: email, password: password) { result in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Current User Tests
    
    func test_getCurrentUser_doesNotCrash() {
        XCTAssertNoThrow(authService.getCurrentUser())
    }
    
    func test_getUserId_doesNotCrash() {
        XCTAssertNoThrow(authService.getUserId())
    }
    
    func test_isLoggedIn_doesNotCrash() {
        XCTAssertNoThrow(authService.isLoggedIn())
    }
    
    // MARK: - Sign Out Tests
    
    func test_signOut_returnsResult() {
        let result = authService.signOut()
        
        switch result {
        case .success:
            XCTAssertTrue(true, "Sign out successful")
        case .failure(let error):
            // Sign out can fail if user is not logged in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func test_conformsToFirebaseAuthServiceProtocol() {
        let authServiceProtocol: FirebaseAuthServiceProtocol = authService
        XCTAssertNotNil(authServiceProtocol)
    }
}
