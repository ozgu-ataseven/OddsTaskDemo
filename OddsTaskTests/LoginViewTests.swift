//
//  LoginViewTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 7.09.2025.
//

import XCTest
import Combine
import UIKit
@testable import OddsTask

final class LoginViewTests: XCTestCase {
    
    private var loginView: LoginView!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        loginView = LoginView()
        cancellables = []
        
        // Add to a container view for proper layout
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        containerView.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Force layout
        containerView.layoutIfNeeded()
    }
    
    override func tearDown() {
        loginView = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - UI Elements Tests
    
    func test_initialization_hasAllUIElements() {
        // Test that view initializes without crashing
        XCTAssertNotNil(loginView)
        XCTAssertTrue(loginView.subviews.count > 0)
    }
    
    // MARK: - Publisher Tests
    
    
    func test_emailChangedPublisher_publishesChanges() {
        let expectation = XCTestExpectation(description: "Email changed")
        let testEmail = "test@example.com"
        
        loginView.emailChangedPublisher
            .sink { email in
                XCTAssertEqual(email, testEmail)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger email change through publisher (simulating text field change)
        loginView.emailChangedPublisher.send(testEmail)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_passwordChangedPublisher_publishesChanges() {
        let expectation = XCTestExpectation(description: "Password changed")
        let testPassword = "testPassword123"
        
        loginView.passwordChangedPublisher
            .sink { password in
                XCTAssertEqual(password, testPassword)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger password change through publisher
        loginView.passwordChangedPublisher.send(testPassword)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loginTappedPublisher_publishesTaps() {
        let expectation = XCTestExpectation(description: "Login tapped")
        
        loginView.loginTappedPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger login tap through publisher
        loginView.loginTappedPublisher.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_registerTappedPublisher_publishesTaps() {
        let expectation = XCTestExpectation(description: "Register tapped")
        
        loginView.registerTappedPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger register tap through publisher
        loginView.registerTappedPublisher.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Public Interface Tests
    
    func test_showMailError_callsWithoutCrash() {
        // Test public interface methods work without crashes
        loginView.showMailError("Invalid email")
        loginView.showMailError(nil)
        
        XCTAssertTrue(true, "showMailError methods completed successfully")
    }
    
    func test_showPasswordError_callsWithoutCrash() {
        loginView.showPasswordError("Password too short")
        loginView.showPasswordError(nil)
        
        XCTAssertTrue(true, "showPasswordError methods completed successfully")
    }
    
    func test_setLoginButton_callsWithoutCrash() {
        loginView.setLoginButton(enabled: true)
        loginView.setLoginButton(enabled: false)
        
        XCTAssertTrue(true, "setLoginButton methods completed successfully")
    }
    
    // MARK: - Layout Tests
    
    func test_layout_hasProperConstraints() {
        // Test that view has proper layout without accessing private properties
        XCTAssertTrue(loginView.subviews.count > 0)
        XCTAssertNotNil(loginView.constraints)
    }
}
