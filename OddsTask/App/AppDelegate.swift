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
        let networkService = NetworkService()
        let authService = AuthenticationService()
        let analyticsService = FirebaseAnalyticsService()
        let apiService = OddsAPIService(network: networkService)
        let basketService = BasketService()
        
        dependencyContainer = DependencyContainer(
            userDefaultsService: userDefaultsService,
            apiService: apiService,
            authService: authService,
            analyticsService: analyticsService,
            basketService: basketService
        )
        AppRouter.shared.setup(with: dependencyContainer)
    }

    private func launchInitialViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AppRouter.shared.navigationRootViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
