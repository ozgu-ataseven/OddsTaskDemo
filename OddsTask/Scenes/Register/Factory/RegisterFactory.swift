//
//  RegisterFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import UIKit

protocol RegisterFactoryProtocol {
    func makeRegisterViewController() -> UIViewController
}

final class RegisterFactory: RegisterFactoryProtocol {
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makeRegisterViewController() -> UIViewController {
        let authService: AuthenticationServiceProtocol = AuthenticationService()
        let viewModel = RegisterViewModel(authService: authService)
        let viewController = RegisterViewController(viewModel: viewModel, router: AppRouter.shared)
        return viewController
    }
}
