//
//  OddEventDetailCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol OddEventDetailCoordinatorDelegate: AnyObject {
    func oddEventDetailCoordinatorDidFinish(_ coordinator: OddEventDetailCoordinator)
}

final class OddEventDetailCoordinator: BaseCoordinator {
    var delegate: OddEventDetailCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    private let sportKey: String
    private let eventId: String
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer, sportKey: String, eventId: String) {
        self.dependencyContainer = dependencyContainer
        self.sportKey = sportKey
        self.eventId = eventId
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showOddEventDetail()
    }
    
    // MARK: - Navigation Methods
    
    private func showOddEventDetail() {
        let apiService = dependencyContainer.resolve(OddsAPIServiceProtocol.self)
        let authService = dependencyContainer.resolve(FirebaseAuthServiceProtocol.self)
        let basketService = dependencyContainer.resolve(BasketServiceProtocol.self)
        
        let viewModel = OddEventDetailViewModel(
            apiService: apiService,
            basketService: basketService,
            authService: authService,
            sportKey: sportKey,
            eventId: eventId
        )
        viewModel.coordinatorDelegate = self
        
        let viewController = OddEventDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
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

// MARK: - OddEventDetailViewModelCoordinatorDelegate

extension OddEventDetailCoordinator: OddEventDetailViewModelCoordinatorDelegate {
    func oddEventDetailViewModelDidAddToBasket() {
        showBasket()
    }
}

// MARK: - BasketCoordinatorDelegate

extension OddEventDetailCoordinator: BasketCoordinatorDelegate {
    func basketCoordinatorDidFinish(_ coordinator: BasketCoordinator) {
        removeChild(coordinator)
    }
}
