//
//  SportListCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol SportListCoordinatorDelegate: AnyObject {
    func sportListCoordinatorDidLogout(_ coordinator: SportListCoordinator)
}

final class SportListCoordinator: BaseCoordinator {
    var delegate: SportListCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showSportList()
    }
    
    // MARK: - Navigation Methods
    
    private func showSportList() {
        let apiService = dependencyContainer.resolve(OddsAPIServiceProtocol.self)
        let authService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        
        let viewModel = SportListViewModel(
            apiService: apiService,
            authService: authService,
            searchFilter: ContainsSportsSearchFiltering()
        )
        viewModel.coordinatorDelegate = self
        
        let viewController = SportListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showOddEventList(sportKey: String) {
        let oddEventListCoordinator = OddEventListCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer,
            sportKey: sportKey
        )
        oddEventListCoordinator.delegate = self
        addChild(oddEventListCoordinator)
        oddEventListCoordinator.start()
    }
    
    private func showBasket() {
        let basketCoordinator = BasketCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        basketCoordinator.delegate = self
        addChild(basketCoordinator)
        basketCoordinator.start()
    }
}

// MARK: - SportListViewModelCoordinatorDelegate

extension SportListCoordinator: SportListViewModelCoordinatorDelegate {
    func sportListViewModelDidSelectSport(sportKey: String) {
        showOddEventList(sportKey: sportKey)
    }
    
    func sportListViewModelDidRequestBasket() {
        showBasket()
    }
    
    func sportListViewModelDidRequestLogout() {
        delegate?.sportListCoordinatorDidLogout(self)
    }
}

// MARK: - OddEventListCoordinatorDelegate

extension SportListCoordinator: OddEventListCoordinatorDelegate {
    func oddEventListCoordinatorDidFinish(_ coordinator: OddEventListCoordinator) {
        removeChild(coordinator)
    }
}

// MARK: - BasketCoordinatorDelegate

extension SportListCoordinator: BasketCoordinatorDelegate {
    func basketCoordinatorDidFinish(_ coordinator: BasketCoordinator) {
        removeChild(coordinator)
    }
}
