//
//  CoordinatorProtocol.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var parentCoordinator: CoordinatorProtocol? { get set }
    
    func start()
    func finish()
    func addChild(_ coordinator: CoordinatorProtocol)
    func removeChild(_ coordinator: CoordinatorProtocol)
}

extension CoordinatorProtocol {
    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
        coordinator.parentCoordinator = nil
    }
    
    func finish() {
        childCoordinators.removeAll()
        parentCoordinator?.removeChild(self)
    }
}

// MARK: - Base Coordinator

class BaseCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parentCoordinator: CoordinatorProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Start method must be implemented by subclass")
    }
}
