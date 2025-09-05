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
        let auth: AuthenticationServiceProtocol = dependencyContainer.resolve()
        let analytics: AnalyticsServiceProtocol = dependencyContainer.resolve()
        return LoginFactory(
            authService: auth,
            analyticsService: analytics,
            router: router
        )
    }

    private func makeRegisterFactory(router: RouterProtocol) -> RegisterFactory {
        let auth: AuthenticationServiceProtocol = dependencyContainer.resolve()
        return RegisterFactory(
            authService: auth,
            router: router
        )
    }

    private func makeSportListFactory(router: RouterProtocol) -> SportListFactory {
        let api: OddsAPIServiceProtocol = dependencyContainer.resolve()
        let auth: AuthenticationServiceProtocol = dependencyContainer.resolve()
        return SportListFactory(
            apiService: api,
            authService: auth,
            router: router
        )
    }

    private func makeOddEventListFactory(router: RouterProtocol) -> OddEventListFactory {
        let api: OddsAPIServiceProtocol = dependencyContainer.resolve()
        return OddEventListFactory(
            apiService: api,
            router: router
        )
    }

    private func makeOddEventDetailFactory(router: RouterProtocol) -> OddEventDetailFactory {
        let api: OddsAPIServiceProtocol = dependencyContainer.resolve()
        let auth: AuthenticationServiceProtocol = dependencyContainer.resolve()
        let basket: BasketServiceProtocol = dependencyContainer.resolve()
        return OddEventDetailFactory(
            apiService: api,
            authService: auth,
            basketService: basket,
            router: router
        )
    }

    private func makeBasketFactory(router: RouterProtocol) -> BasketFactory {
        let auth: AuthenticationServiceProtocol = dependencyContainer.resolve()
        let basket: BasketServiceProtocol = dependencyContainer.resolve()
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
