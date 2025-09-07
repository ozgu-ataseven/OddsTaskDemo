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
    private let authService: FirebaseAuthServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol

    init(authService: FirebaseAuthServiceProtocol, analyticsService: AnalyticsServiceProtocol) {
        self.authService = authService
        self.analyticsService = analyticsService
    }

    func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(authService: authService, analyticsService: analyticsService)
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }
}
