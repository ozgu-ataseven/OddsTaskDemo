//
//  OddEventListFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit

protocol OddEventListFactoryProtocol {
    func makeOddEventListViewController(sportKey: String) -> UIViewController
}

final class OddEventListFactory: OddEventListFactoryProtocol {
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makeOddEventListViewController(sportKey: String) -> UIViewController {
        let viewModel = OddEventListViewModel(
            apiService: dependencyContainer.apiService,
            sportKey: sportKey,
            searchFilter: ContainsOddsSearchFiltering()
        )
        let viewController = OddEventListViewController(viewModel: viewModel, router: AppRouter.shared)
        return viewController
    }
}
