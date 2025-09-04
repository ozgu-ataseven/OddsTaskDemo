//
//  AppFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
import FirebaseAuth

final class AppFactory {

    private let dependencyContainer: DependencyContainer
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    private lazy var authService: AuthenticationServiceProtocol = AuthenticationService()
    private lazy var analyticsService: AnalyticsServiceProtocol = FirebaseAnalyticsService()
    private lazy var apiService: OddsAPIServiceProtocol = OddsAPIService(network: networkService)
    private lazy var basketService: BasketServiceProtocol = BasketService()

    private lazy var loginFactory = LoginFactory(
        authService: authService,
        analyticsService: analyticsService,
        router: AppRouter.shared
    )
    private lazy var registerFactory = RegisterFactory(
        authService: authService,
        router: AppRouter.shared
    )
    private lazy var sportListFactory = SportListFactory(
        apiService: apiService,
        authService: authService,
        router: AppRouter.shared
    )
    private lazy var oddEventListFactory = OddEventListFactory(
        apiService: apiService,
        router: AppRouter.shared
    )
    private lazy var oddEventDetailFactory = OddEventDetailFactory(
        apiService: apiService,
        authService: authService,
        basketService: basketService,
        router: AppRouter.shared
    )
    private lazy var basketFactory = BasketFactory(
        authService: authService,
        basketService: basketService,
        router: AppRouter.shared
    )

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func initialViewController() -> UIViewController {
        if Auth.auth().currentUser != nil {
            return sportListFactory.makeSportListViewController()
        } else {
            return loginFactory.makeLoginViewController()
        }
    }

    func loginViewController() -> UIViewController {
        return loginFactory.makeLoginViewController()
    }

    func registerViewController() -> UIViewController {
        return registerFactory.makeRegisterViewController()
    }

    func sportListViewController() -> UIViewController {
        return sportListFactory.makeSportListViewController()
    }

    func oddListViewController(sportKey: String) -> UIViewController {
        return oddEventListFactory.makeOddEventListViewController(sportKey: sportKey)
    }
    
    func oddEventDetailViewController(sportKey: String, eventId: String)-> UIViewController {
        return oddEventDetailFactory.makeOddEventDetailViewController(sportKey: sportKey, eventId: eventId)
    }
    
    func basketViewController() -> UIViewController {
        return basketFactory.makBasketViewController()
    }
}
