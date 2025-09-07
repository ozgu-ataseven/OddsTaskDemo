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
    private let authService: FirebaseAuthServiceProtocol

    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }

    func makeRegisterViewController() -> UIViewController {
        let viewModel = RegisterViewModel(authService: authService)
        let viewController = RegisterViewController(viewModel: viewModel)
        return viewController
    }
}
