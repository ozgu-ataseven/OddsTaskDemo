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

    init(apiService: OddsAPIServiceProtocol) {
        self.apiService = apiService
    }

    func makeOddEventListViewController(sportKey: String) -> UIViewController {
        let viewModel = OddEventListViewModel(
            apiService: apiService,
            sportKey: sportKey,
            searchFilter: ContainsOddsSearchFiltering()
        )
        let viewController = OddEventListViewController(viewModel: viewModel)
        return viewController
    }
}
