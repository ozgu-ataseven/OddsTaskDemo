//
//  OddEventListCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol OddEventListCoordinatorDelegate: AnyObject {
    func oddEventListCoordinatorDidFinish(_ coordinator: OddEventListCoordinator)
}

final class OddEventListCoordinator: BaseCoordinator {
    var delegate: OddEventListCoordinatorDelegate?
    private let dependencyContainer: DependencyContainer
    private let sportKey: String
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer, sportKey: String) {
        self.dependencyContainer = dependencyContainer
        self.sportKey = sportKey
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showOddEventList()
    }
    
    // MARK: - Navigation Methods
    
    private func showOddEventList() {
        let apiService = dependencyContainer.resolve(OddsAPIServiceProtocol.self)
        
        let viewModel = OddEventListViewModel(
            apiService: apiService,
            sportKey: sportKey,
            searchFilter: ContainsOddsSearchFiltering()
        )
        viewModel.coordinatorDelegate = self
        
        let viewController = OddEventListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showOddEventDetail(sportKey: String, eventId: String) {
        let oddEventDetailCoordinator = OddEventDetailCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer,
            sportKey: sportKey,
            eventId: eventId
        )
        oddEventDetailCoordinator.delegate = self
        addChild(oddEventDetailCoordinator)
        oddEventDetailCoordinator.start()
    }
}

// MARK: - OddEventListViewModelCoordinatorDelegate

extension OddEventListCoordinator: OddEventListViewModelCoordinatorDelegate {
    func oddEventListViewModelDidSelectEvent(sportKey: String, eventId: String) {
        showOddEventDetail(sportKey: sportKey, eventId: eventId)
    }
}

// MARK: - OddEventDetailCoordinatorDelegate

extension OddEventListCoordinator: OddEventDetailCoordinatorDelegate {
    func oddEventDetailCoordinatorDidFinish(_ coordinator: OddEventDetailCoordinator) {
        removeChild(coordinator)
    }
}
