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
    private let apiService: OddsAPIServiceProtocol
    private weak var router: RouterProtocol?

    init(apiService: OddsAPIServiceProtocol, router: RouterProtocol) {
        self.apiService = apiService
        self.router = router
    }

    func makeOddEventListViewController(sportKey: String) -> UIViewController {
        let viewModel = OddEventListViewModel(
            apiService: apiService,
            sportKey: sportKey,
            searchFilter: ContainsOddsSearchFiltering()
        )
        let viewController = OddEventListViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
