//
//  MockServices.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 7.09.2025.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth
@testable import OddsTask

// MARK: - Mock Firebase Auth Service

final class MockFirebaseAuthService: FirebaseAuthServiceProtocol {
    var shouldSucceed: Bool = true
    var mockUserId: String? = "mockUserId"
    var errorType: AuthError = .unknownAuthError("Mock error")
    
    func login(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                completion(.success(()))
            } else {
                completion(.failure(self.errorType))
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                completion(.success(()))
            } else {
                completion(.failure(self.errorType))
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return nil
    }
    
    func getUserId() -> String? {
        return mockUserId
    }
    
    func signOut() -> Result<Void, AuthError> {
        return shouldSucceed ? .success(()) : .failure(errorType)
    }
    
    func isLoggedIn() -> Bool {
        return mockUserId != nil
    }
}

// MARK: - Mock Analytics Service

final class MockAnalyticsService: AnalyticsServiceProtocol {
    var loggedEvents: [(name: String, parameters: [String: Any]?)] = []
    var loggedScreenViews: [String] = []
    var loggedUserProperties: [(name: String, value: String)] = []
    
    func logEvent(name: String, parameters: [String : Any]?) {
        loggedEvents.append((name: name, parameters: parameters))
    }
    
    func logScreenView(screenName: String) {
        loggedScreenViews.append(screenName)
    }
    
    func logUserProperty(name: String, value: String) {
        loggedUserProperties.append((name: name, value: value))
    }
}

// MARK: - Mock UserDefaults Service

final class MockUserDefaultsService: UserDefaultsServiceProtocol {
    public let userDefaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }
    
    func set(data: Any, forKey: UserDefaultsService.Keys) { }
    
    func value<T>(forKey: UserDefaultsService.Keys) -> T? {
        return nil
    }
    
    func setObject<T>(data: T, forKey: UserDefaultsService.Keys) where T : Decodable, T : Encodable { }
    
    func getObject<T>(forKey: UserDefaultsService.Keys) -> T? where T : Decodable, T : Encodable {
        return nil
    }
    
    func removeAll() { }
    
    func set<T>(_ value: T?, forKey key: String) where T : Encodable { }
    func value<T>(forKey key: String) -> T? where T : Decodable { return nil }
    func removeValue(forKey key: String) { }
}

// MARK: - Mock Basket Service

final class MockBasketService: BasketServiceProtocol {
    var shouldSucceed: Bool = true
    var mockItems: [BasketItem] = []
    var mockError: BusinessError = .invalidOperation("Mock error")
    
    func addItem(_ item: BasketItem, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                self.mockItems.append(item)
                completion(.success(()))
            } else {
                completion(.failure(self.mockError))
            }
        }
    }
    
    func fetchItems(for userId: String, completion: @escaping (Result<[BasketItem], BusinessError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                completion(.success(self.mockItems))
            } else {
                completion(.failure(self.mockError))
            }
        }
    }
    
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                self.mockItems.removeAll { $0.id == itemId }
                completion(.success(()))
            } else {
                completion(.failure(self.mockError))
            }
        }
    }
    
    func clearBasket(for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if self.shouldSucceed {
                self.mockItems.removeAll()
                completion(.success(()))
            } else {
                completion(.failure(self.mockError))
            }
        }
    }
}

// MARK: - Mock Odds API Service

final class MockOddsAPIService: OddsAPIServiceProtocol {
    var shouldSucceedSports: Bool = true
    var shouldSucceedOddEvents: Bool = true
    var shouldSucceedEventDetail: Bool = true
    
    var mockOddEvents: [OddEvent] = []
    var mockEventDetail: OddEventDetail?
    
    func getAllSports() -> AnyPublisher<[Sport], NetworkError> {
        if shouldSucceedSports {
            return Just(mockSports)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.serverError(statusCode: 500, message: "Mock error"))
                .eraseToAnyPublisher()
        }
    }
    
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError> {
        if shouldSucceedOddEvents {
            return Just(mockOddEvents)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.serverError(statusCode: 500, message: "Mock error"))
                .eraseToAnyPublisher()
        }
    }
    
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError> {
        if shouldSucceedEventDetail, let detail = mockEventDetail {
            return Just(detail)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.invalidResponse)
                .eraseToAnyPublisher()
        }
    }
    
    private var mockSports: [Sport] = [
        Sport(key: "football", group: "American Football", title: "NFL", active: true),
        Sport(key: "basketball", group: "Basketball", title: "NBA", active: true)
    ]
}

// MARK: - Mock Network Service

final class MockNetworkService: NetworkServiceProtocol {
    enum MockResult<T> {
        case success(T)
        case failure(NetworkError)
    }
    
    var mockResult: MockResult<Any>?
    
    func request<T>(endpoint: Endpoint, headers: [String: String]?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let result = mockResult else {
            return Fail(error: NetworkError.unknownError("Mock error"))
                .eraseToAnyPublisher()
        }
        
        switch result {
        case .success(let data):
            if let typedData = data as? T {
                return Just(typedData)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.invalidResponse)
                    .eraseToAnyPublisher()
            }
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Mock Router

final class MockRouter: RouterProtocol {
    var pushedRoutes: [Route] = []
    var presentedRoutes: [Route] = []
    var dismissedCount: Int = 0
    var poppedCount: Int = 0
    
    func push(_ route: Route, from source: UIViewController, animated: Bool) {
        pushedRoutes.append(route)
    }
    
    func present(_ route: Route, from source: UIViewController, animated: Bool) {
        presentedRoutes.append(route)
    }
    
    func setRoot(for route: Route, animated: Bool) {
        pushedRoutes = [route]
    }
    
    func dismiss(animated: Bool) {
        dismissedCount += 1
    }
    
    func pop(animated: Bool) {
        poppedCount += 1
    }
}

// MARK: - DependencyContainer Extension

extension DependencyContainer {
    static var mock: DependencyContainer {
        let userDefaultsService = MockUserDefaultsService(defaults: .standard)
        let container = DependencyContainer(userDefaultsService: userDefaultsService)
        
        container.register(OddsAPIServiceProtocol.self, scope: .singleton) { _ in MockOddsAPIService() }
        container.register(FirebaseAuthServiceProtocol.self, scope: .singleton) { _ in MockFirebaseAuthService() }
        container.register(AnalyticsServiceProtocol.self, scope: .singleton) { _ in MockAnalyticsService() }
        container.register(BasketServiceProtocol.self, scope: .singleton) { _ in MockBasketService() }
        
        return container
    }
}

// MARK: - Test Helpers

extension DependencyContainer {
    var mockFirebaseAuthService: MockFirebaseAuthService? {
        return resolve(FirebaseAuthServiceProtocol.self) as? MockFirebaseAuthService
    }
    
    var mockAnalyticsService: MockAnalyticsService? {
        return resolve(AnalyticsServiceProtocol.self) as? MockAnalyticsService
    }
    
    var mockBasketService: MockBasketService? {
        return resolve(BasketServiceProtocol.self) as? MockBasketService
    }
    
    var mockOddsAPIService: MockOddsAPIService? {
        return resolve(OddsAPIServiceProtocol.self) as? MockOddsAPIService
    }
    
    var authService: FirebaseAuthServiceProtocol {
        return resolve(FirebaseAuthServiceProtocol.self)
    }
    
    var analyticsService: AnalyticsServiceProtocol {
        return resolve(AnalyticsServiceProtocol.self)
    }
    
    var basketService: BasketServiceProtocol {
        return resolve(BasketServiceProtocol.self)
    }
    
    var apiService: OddsAPIServiceProtocol {
        return resolve(OddsAPIServiceProtocol.self)
    }
}
