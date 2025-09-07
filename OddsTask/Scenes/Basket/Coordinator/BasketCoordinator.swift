//
//  BasketCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol BasketCoordinatorDelegate: AnyObject {
    func basketCoordinatorDidFinish(_ coordinator: BasketCoordinator)
}

final class BasketCoordinator: BaseCoordinator {
    var delegate: BasketCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showBasket()
    }
    
    // MARK: - Navigation Methods
    
    private func showBasket() {
        let authService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        let basketService = dependencyContainer.resolve(BasketServiceProtocol.self)
        
        let viewModel = BasketViewModel(
            authService: authService,
            basketService: basketService
        )
        viewModel.coordinatorDelegate = self
        
        let viewController = BasketViewController(viewModel: viewModel)
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - BasketViewModelCoordinatorDelegate

extension BasketCoordinator: BasketViewModelCoordinatorDelegate {
    func basketViewModelDidRequestClose() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.basketCoordinatorDidFinish(self)
        }
    }
}
