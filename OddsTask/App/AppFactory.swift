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

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    // MARK: - Private helpers (her çağrıda yeni instance)
    private func makeLoginFactory(router: RouterProtocol) -> LoginFactory {
        let auth = AuthenticationService()
        let analytics = FirebaseAnalyticsService()
        return LoginFactory(
            authService: auth,
            analyticsService: analytics,
            router: router
        )
    }

    private func makeRegisterFactory(router: RouterProtocol) -> RegisterFactory {
        let auth = AuthenticationService()
        return RegisterFactory(
            authService: auth,
            router: router
        )
    }

    private func makeSportListFactory(router: RouterProtocol) -> SportListFactory {
        let network = NetworkService()
        let api = OddsAPIService(network: network)
        let auth = AuthenticationService()
        return SportListFactory(
            apiService: api,
            authService: auth,
            router: router
        )
    }

    private func makeOddEventListFactory(router: RouterProtocol) -> OddEventListFactory {
        let network = NetworkService()
        let api = OddsAPIService(network: network)
        return OddEventListFactory(
            apiService: api,
            router: router
        )
    }

    private func makeOddEventDetailFactory(router: RouterProtocol) -> OddEventDetailFactory {
        let network = NetworkService()
        let api = OddsAPIService(network: network)
        let auth = AuthenticationService()
        let basket = BasketService()
        return OddEventDetailFactory(
            apiService: api,
            authService: auth,
            basketService: basket,
            router: router
        )
    }

    private func makeBasketFactory(router: RouterProtocol) -> BasketFactory {
        let auth = AuthenticationService()
        let basket = BasketService()
        return BasketFactory(
            authService: auth,
            basketService: basket,
            router: router
        )
    }

    // MARK: - ViewController builders (transient)
    func initialViewController(router: RouterProtocol) -> UIViewController {
        if Auth.auth().currentUser != nil {
            return makeSportListFactory(router: router).makeSportListViewController()
        } else {
            return makeLoginFactory(router: router).makeLoginViewController()
        }
    }

    func loginViewController(router: RouterProtocol) -> UIViewController {
        makeLoginFactory(router: router).makeLoginViewController()
    }

    func registerViewController(router: RouterProtocol) -> UIViewController {
        makeRegisterFactory(router: router).makeRegisterViewController()
    }

    func sportListViewController(router: RouterProtocol) -> UIViewController {
        makeSportListFactory(router: router).makeSportListViewController()
    }

    func oddListViewController(sportKey: String, router: RouterProtocol) -> UIViewController {
        makeOddEventListFactory(router: router).makeOddEventListViewController(sportKey: sportKey)
    }

    func oddEventDetailViewController(sportKey: String, eventId: String, router: RouterProtocol) -> UIViewController {
        makeOddEventDetailFactory(router: router).makeOddEventDetailViewController(
            sportKey: sportKey,
            eventId: eventId
        )
    }

    func basketViewController(router: RouterProtocol) -> UIViewController {
        makeBasketFactory(router: router).makeBasketViewController()
    }
}
