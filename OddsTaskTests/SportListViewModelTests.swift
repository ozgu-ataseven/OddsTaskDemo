//
//  SportListViewModelTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 23.05.2025.
//

import XCTest
import Combine
import FirebaseAuth
import Alamofire
@testable import OddsTask

final class SportListViewModelTests: XCTestCase {

    private var viewModel: SportListViewModel!
    private var mockOddsService: MockOddsAPIService!
    private var mockAuthService: MockAuthenticationService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockOddsService = MockOddsAPIService()
        mockAuthService = MockAuthenticationService()
        cancellables = []
        viewModel = SportListViewModel(dependencyContainer: DependencyContainer.mock)
    }

    override func tearDown() {
        viewModel = nil
        mockOddsService = nil
        mockAuthService = nil
        cancellables = nil
        super.tearDown()
    }

    // Tests that fetching sports successfully emits the fetched sports list.
    func test_fetchSports_emitsFetchedSports() {
        let expectation = XCTestExpectation(description: "Sports fetched")

        viewModel.sportsPublisher
            .dropFirst()
            .sink { sports in
                XCTAssertEqual(sports.count, 2)
                XCTAssertEqual(sports.first?.title, "Football")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchSports()

        wait(for: [expectation], timeout: 1.0)
    }

    // Tests that updating the search text filters the sports list correctly.
    func test_searchText_filtersSportsCorrectly() {
        let expectation = XCTestExpectation(description: "Search filtered")

        viewModel.fetchSports()

        // Combine zinciri kurulmadan searchText ataması yapılmamalı
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.searchText = "basket"
        }

        viewModel.sportsPublisher
            .dropFirst(2) // boş -> fetch -> filtreli
            .sink { sports in
                XCTAssertEqual(sports.count, 1)
                XCTAssertEqual(sports.first?.title.lowercased(), "basketball")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    // Tests that a successful logout routes the user to the login screen.
    func test_logout_success_routesToLogin() {
        let expectation = XCTestExpectation(description: "Logged out")

        viewModel.routeLoginPublisher
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockAuthService.shouldSucceed = true
        viewModel.logout()

        wait(for: [expectation], timeout: 1.0)
    }

    // Tests that a logout failure emits an alert with a failure message.
    func test_logout_failure_emitsAlert() {
        let expectation = XCTestExpectation(description: "Alert shown")
        
        mockAuthService = MockAuthenticationService()
        mockAuthService.shouldSucceed = false
        
        let container = DependencyContainer(
            userDefaultsService: MockUserDefaultsService(defaults: .standard),
            apiService: MockOddsAPIService(),
            authService: mockAuthService,
            analyticsService: MockAnalyticsService(),
            basketService: MockBasketService()
        )
        
        viewModel = SportListViewModel(dependencyContainer: container)

        viewModel.alertPublisher
            .sink { alert in
                XCTAssertEqual(alert.title, "Çıkış Başarısız")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockAuthService.shouldSucceed = false
        viewModel.logout()

        wait(for: [expectation], timeout: 1.0)
    }

    // Tests that selecting a sport publishes the correct sport key for routing.
    func test_didSelectSport_emitsCorrectSportKey() {
        let expectation = XCTestExpectation(description: "Correct sport key routed")
        let testSport = Sport(key: "basketball", title: "Basketball")

        viewModel.routeEventListPublisher
            .sink { key in
                XCTAssertEqual(key, testSport.key)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.didSelectSport(testSport)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchSports_setsLoadingStateCorrectly() {
        let expectation = XCTestExpectation(description: "Loading states match")
        expectation.expectedFulfillmentCount = 2 // expecting both true and false

        var loadingStates: [Bool] = []

        viewModel.loadingPublisher
            .dropFirst() // ignore the initial value
            .sink { isLoading in
                loadingStates.append(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchSports()

        wait(for: [expectation], timeout: 2.0)

        XCTAssertEqual(loadingStates, [true, false])
    }
}

// MARK: - Mock Services

final class MockOddsAPIService: OddsAPIServiceProtocol {
    init() {}
    
    func getAllSports() -> AnyPublisher<[Sport], NetworkError> {
        return Just(stubbedSports)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError> {
        return Just([]).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
    
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError> {
        return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
    }
    
    var stubbedSports: [Sport] = [
        Sport(key: "1", group: "", title: "Football", active: true),
        Sport(key: "2", group: "", title: "Basketball", active: true)
    ]
}

final class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldSucceed: Bool = true

    func login(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        if shouldSucceed {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "mock", code: 0, userInfo: nil)))
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        if shouldSucceed {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "mock", code: 0, userInfo: nil)))
        }
    }
    
    func getCurrentUser() -> FirebaseAuth.User? {
        return nil
    }
    
    func getUserId() -> String? {
        return "mockUserId"
    }
    
    func signOut() -> Result<Void, Error> {
        return shouldSucceed ? .success(()) : .failure(NSError(domain: "logout", code: 1))
    }
}

extension DependencyContainer {
    static var mock: DependencyContainer {
        let userDefaultsService = MockUserDefaultsService(defaults: .standard)
        let apiService = MockOddsAPIService()
        let authService = MockAuthenticationService()
        let analyticsService = MockAnalyticsService()
        let basketService = MockBasketService()
        
        return .init(
            userDefaultsService: userDefaultsService,
            apiService: apiService,
            authService: authService,
            analyticsService: analyticsService,
            basketService: basketService
        )
    }
}

final class MockNetworkService: NetworkServiceProtocol {
    func request<T>(endpoint: OddsAPIEndpoint, headers: HTTPHeaders?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
    }
}

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

final class MockAnalyticsService: AnalyticsServiceProtocol {
    func logEvent(name: String, parameters: [String : Any]?) {
        
    }
    
    func logScreenView(screenName: String) {
        
    }
    
    func logUserProperty(name: String, value: String) {
        
    }
}


final class MockBasketService: BasketServiceProtocol {
    func addItem(_ item: OddsTask.BasketItem, for userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    func fetchItems(for userId: String, completion: @escaping (Result<[OddsTask.BasketItem], any Error>) -> Void) {
        
    }
    
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    func clearBasket(for userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
}
