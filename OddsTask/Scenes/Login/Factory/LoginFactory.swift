//
//  LoginFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import UIKit

protocol LoginFactoryProtocol {
    func makeLoginViewController() -> UIViewController
}

final class LoginFactory: LoginFactoryProtocol {
    private let authService: AuthenticationServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    private let router: RouterProtocol

    init(authService: AuthenticationServiceProtocol, analyticsService: AnalyticsServiceProtocol, router: RouterProtocol) {
        self.authService = authService
        self.analyticsService = analyticsService
        self.router = router
    }

    func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(authService: authService, analyticsService: analyticsService)
        let viewController = LoginViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
