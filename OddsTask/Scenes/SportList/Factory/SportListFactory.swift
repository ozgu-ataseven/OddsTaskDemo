//
//  SportListFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import UIKit

protocol SportListFactoryProtocol {
    func makeSportListViewController() -> UIViewController
}

final class SportListFactory: SportListFactoryProtocol {
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makeSportListViewController() -> UIViewController {
        let viewModel = SportListViewModel(
            apiService: dependencyContainer.apiService,
            authService: dependencyContainer.authService
        )
        let viewController = SportListViewController(viewModel: viewModel, router: AppRouter.shared)
        return viewController
    }
}
