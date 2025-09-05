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
    private let authService: AuthenticationServiceProtocol
    private weak var router: RouterProtocol?

    init(authService: AuthenticationServiceProtocol, router: RouterProtocol) {
        self.authService = authService
        self.router = router
    }

    func makeRegisterViewController() -> UIViewController {
        let viewModel = RegisterViewModel(authService: authService)
        let viewController = RegisterViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
