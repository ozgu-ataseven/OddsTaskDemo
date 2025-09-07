//
//  AppCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 6.09.2025.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let dependencyContainer: DependencyContainer
    private let firebaseService: FirebaseAuthServiceProtocol
    private var currentCoordinator: CoordinatorProtocol?

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.firebaseService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        if firebaseService.isLoggedIn() {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    // MARK: - Navigation Methods
    
    private func showAuthFlow() {
        let loginCoordinator = LoginCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        loginCoordinator.delegate = self
        addChild(loginCoordinator)
        currentCoordinator = loginCoordinator
        loginCoordinator.start()
    }
    
    private func showMainFlow() {
        let sportListCoordinator = SportListCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        sportListCoordinator.delegate = self
        addChild(sportListCoordinator)
        currentCoordinator = sportListCoordinator
        sportListCoordinator.start()
    }
}

// MARK: - LoginCoordinatorDelegate

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDidFinishLogin(_ coordinator: LoginCoordinator) {
        removeChild(coordinator)
        showMainFlow()
    }
}

// MARK: - SportListCoordinatorDelegate

extension AppCoordinator: SportListCoordinatorDelegate {
    func sportListCoordinatorDidLogout(_ coordinator: SportListCoordinator) {
        removeChild(coordinator)
        showAuthFlow()
    }
}
