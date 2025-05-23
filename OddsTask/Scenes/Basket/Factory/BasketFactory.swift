//
//  BasketFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import UIKit

protocol BasketFactoryProtocol {
    func makBasketViewController() -> UIViewController
}

final class BasketFactory: BasketFactoryProtocol {
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makBasketViewController() -> UIViewController {
        let authService = AuthenticationService()
        let basketService = BasketService()
        let viewModel = BasketViewModel(dependencyContainer: dependencyContainer, authService: authService, basketService: basketService)
        let viewController = BasketViewController(viewModel: viewModel)
        return viewController
    }
}
