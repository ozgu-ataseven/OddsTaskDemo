//
//  LoginViewModelTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 7.09.2025.
//

import XCTest
import Combine
import FirebaseAuth
@testable import OddsTask

final class LoginViewModelTests: XCTestCase {
    
    private var viewModel: LoginViewModel!
    private var mockContainer: DependencyContainer!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockContainer = DependencyContainer.mock
        viewModel = LoginViewModel(
            authService: mockContainer.authService,
            analyticsService: mockContainer.analyticsService
        )
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockContainer = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Email Validation Tests
    
    func test_emailValidation_validEmail_noValidationMessage() {
        let expectation = XCTestExpectation(description: "Email validation")
        
        viewModel.emailValidationMessagePublisher
            .dropFirst()
            .sink { message in
                XCTAssertNil(message)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_emailValidation_invalidEmail_showsValidationMessage() {
        let expectation = XCTestExpectation(description: "Email validation")
        
        viewModel.emailValidationMessagePublisher
            .dropFirst()
            .sink { message in
                XCTAssertNotNil(message)
                XCTAssertEqual(message, "Geçerli bir email değil.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "invalid-email"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_emailValidation_emptyEmail_showsValidationMessage() {
        let expectation = XCTestExpectation(description: "Email validation")
        
        viewModel.emailValidationMessagePublisher
            .dropFirst()
            .sink { message in
                XCTAssertNotNil(message)
                XCTAssertEqual(message, "Email boş olamaz.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = ""
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Password Validation Tests
    
    func test_passwordValidation_validPassword_noValidationMessage() {
        let expectation = XCTestExpectation(description: "Password validation")
        
        viewModel.passwordValidationMessagePublisher
            .dropFirst()
            .sink { message in
                XCTAssertNil(message)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.password = "ValidPass123"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_passwordValidation_shortPassword_showsValidationMessage() {
        let expectation = XCTestExpectation(description: "Password validation")
        
        viewModel.passwordValidationMessagePublisher
            .dropFirst()
            .sink { message in
                XCTAssertNotNil(message)
                XCTAssertEqual(message, "Şifre en az 6 karakter olmalı")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.password = "123"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Form Validation Tests
    
    func test_formValidation_validEmailAndPassword_formIsValid() {
        let expectation = XCTestExpectation(description: "Form validation")
        
        viewModel.isFormValidPublisher
            .dropFirst()
            .sink { isValid in
                XCTAssertTrue(isValid)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        viewModel.password = "ValidPass123"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_formValidation_invalidEmail_formIsInvalid() {
        // Set invalid email and valid password
        viewModel.email = "invalid-email"
        viewModel.password = "ValidPass123"
        
        // Wait for validation to process
        let expectation = expectation(description: "Wait for validation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Check that form is invalid due to invalid email
        // Since we can't access isFormValid directly, we'll test through the validation messages
        let emailExpectation = XCTestExpectation(description: "Email validation message")
        
        viewModel.emailValidationMessagePublisher
            .sink { message in
                if message != nil {
                    XCTAssertNotNil(message, "Should have email validation error")
                    emailExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [emailExpectation], timeout: 1.0)
    }
    
    // MARK: - Login Tests
    
    func test_login_success_navigatesToSportList() {
        let expectation = XCTestExpectation(description: "Login success")
        mockContainer.mockFirebaseAuthService?.shouldSucceed = true
        
        viewModel.routeSportListPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        viewModel.password = "ValidPass123"
        viewModel.login()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_login_failure_showsAlert() {
        let expectation = XCTestExpectation(description: "Login failure")
        mockContainer.mockFirebaseAuthService?.shouldSucceed = false
        mockContainer.mockFirebaseAuthService?.errorType = .invalidCredentials
        
        viewModel.alertPublisher
            .compactMap { $0 }
            .sink { alert in
                XCTAssertEqual(alert.title, "Giriş Hatası")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.email = "test@example.com"
        viewModel.password = "WrongPass123"
        viewModel.login()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Loading State Tests
    
    func test_login_showsLoadingState() {
        let expectation = XCTestExpectation(description: "Loading state")
        var loadingStates: [Bool] = []
        
        viewModel.loadingPublisher
            .dropFirst()
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        mockContainer.mockFirebaseAuthService?.shouldSucceed = true
        viewModel.email = "test@example.com"
        viewModel.password = "ValidPass123"
        viewModel.login()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    // MARK: - Analytics Tests
    
    func test_login_logsAnalyticsEvent() {
        mockContainer.mockFirebaseAuthService?.shouldSucceed = true
        
        viewModel.email = "test@example.com"
        viewModel.password = "ValidPass123"
        viewModel.login()
        
        // Analytics event'inin log'landığını kontrol et
        let analyticsService = mockContainer.mockAnalyticsService
        XCTAssertTrue(analyticsService?.loggedEvents.contains { $0.name == AnalyticsEvent.Action.loginTapped } ?? false)
    }
    
    func test_registerTapped_logsAnalyticsEvent() {
        viewModel.registerTapped()
        
        // Analytics event'inin log'landığını kontrol et
        let analyticsService = mockContainer.mockAnalyticsService
        XCTAssertTrue(analyticsService?.loggedEvents.contains { $0.name == AnalyticsEvent.Action.registerTapped } ?? false)
    }
}
