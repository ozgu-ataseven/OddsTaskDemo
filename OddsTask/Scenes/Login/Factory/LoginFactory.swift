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
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(dependencyContainer: dependencyContainer)
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }
}
