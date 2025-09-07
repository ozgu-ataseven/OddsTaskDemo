//
//  RegisterCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol RegisterCoordinatorDelegate: AnyObject {
    func registerCoordinatorDidFinishRegistration(_ coordinator: RegisterCoordinator)
    func registerCoordinatorDidCancel(_ coordinator: RegisterCoordinator)
}

final class RegisterCoordinator: BaseCoordinator {
    var delegate: RegisterCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showRegister()
    }
    
    // MARK: - Navigation Methods
    
    private func showRegister() {
        let authService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        
        let viewModel = RegisterViewModel(authService: authService)
        viewModel.coordinatorDelegate = self
        
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RegisterViewModelCoordinatorDelegate

extension RegisterCoordinator: RegisterViewModelCoordinatorDelegate {
    func registerViewModelDidFinishRegistration() {
        delegate?.registerCoordinatorDidFinishRegistration(self)
    }
    
    func registerViewModelDidRequestLogin() {
        delegate?.registerCoordinatorDidCancel(self)
    }
}
