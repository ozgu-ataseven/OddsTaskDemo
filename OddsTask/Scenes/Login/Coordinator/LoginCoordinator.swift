//
//  LoginCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func loginCoordinatorDidFinishLogin(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: BaseCoordinator {
    var delegate: LoginCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showLogin()
    }
    
    // MARK: - Navigation Methods
    
    private func showLogin() {
        let authService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        let analyticsService = dependencyContainer.resolve(AnalyticsServiceProtocol.self)
        
        let viewModel = LoginViewModel(
            authService: authService,
            analyticsService: analyticsService
        )
        viewModel.coordinatorDelegate = self
        
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showRegister() {
        let registerCoordinator = RegisterCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        registerCoordinator.delegate = self
        addChild(registerCoordinator)
        registerCoordinator.start()
    }
}

// MARK: - LoginViewModelCoordinatorDelegate

extension LoginCoordinator: LoginViewModelCoordinatorDelegate {
    func loginViewModelDidFinishLogin() {
        delegate?.loginCoordinatorDidFinishLogin(self)
    }
    
    func loginViewModelDidRequestRegister() {
        showRegister()
    }
}

// MARK: - RegisterCoordinatorDelegate

extension LoginCoordinator: RegisterCoordinatorDelegate {
    func registerCoordinatorDidFinishRegistration(_ coordinator: RegisterCoordinator) {
        removeChild(coordinator)
        delegate?.loginCoordinatorDidFinishLogin(self)
    }
    
    func registerCoordinatorDidCancel(_ coordinator: RegisterCoordinator) {
        removeChild(coordinator)
        navigationController.popViewController(animated: true)
    }
}
