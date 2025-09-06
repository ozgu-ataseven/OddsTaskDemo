//
//  AppDelegate.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 16.05.2025.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var dependencyContainer: DependencyContainer!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureFirebase()
        configureKeyboard()
        configureTheme()
        setupDependencies()
        launchInitialViewController()
        return true
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }

    private func configureKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }

    private func configureTheme() {
        ThemeManager.shared.apply(theme: .dark)
    }

    private func setupDependencies() {
        let userDefaultsService = UserDefaultsService(defaults: .standard)
        dependencyContainer = DependencyContainer(
            userDefaultsService: userDefaultsService
        )

        // Core/config
        dependencyContainer.register(APIConfiguration.self, scope: .singleton) { _ in
            APIConfiguration()
        }

        dependencyContainer.register(NetworkLogger.self, scope: .singleton) { _ in
            NetworkLogger()
        }
        
        dependencyContainer.register(AnalyticsServiceProtocol.self, scope: .singleton) { _ in
            FirebaseAnalyticsService()
        }

        // Networking
        dependencyContainer.register(NetworkServiceProtocol.self, scope: .singleton) { c in
            NetworkService(
                configuration: c.resolve(APIConfiguration.self),
                logger: c.resolve(NetworkLogger.self)
            )
        }

        // Domain services
        dependencyContainer.register(OddsAPIServiceProtocol.self, scope: .singleton) { c in
            OddsAPIService(network: c.resolve(NetworkServiceProtocol.self))
        }

        dependencyContainer.register(FirebaseAuthServiceProtocol.self, scope: .singleton) { c in
            FirebaseAuthService()
        }

        dependencyContainer.register(BasketServiceProtocol.self, scope: .singleton) { c in
            BasketService()
        }

        // Router / Factory will resolve dependencies from container
        AppRouter.shared.setup(with: dependencyContainer)
    }

    private func launchInitialViewController() {
        let router = AppRouter.shared
        let factory = AppFactory(dependencyContainer: dependencyContainer)
        let coordinator = AppCoordinator(router: router, factory: factory, firebaseService: dependencyContainer.resolve())
        let initialVC = coordinator.makeInitialRootViewController()
        router.installRoot(initialVC)
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = router.navigationRootViewController()
        window.makeKeyAndVisible()
    }
}
