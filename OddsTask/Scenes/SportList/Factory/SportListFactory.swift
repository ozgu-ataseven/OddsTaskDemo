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
    private let apiService: OddsAPIServiceProtocol
    private let authService: FirebaseAuthServiceProtocol

    init(apiService: OddsAPIServiceProtocol, authService: FirebaseAuthServiceProtocol) {
        self.apiService = apiService
        self.authService = authService
    }

    func makeSportListViewController() -> UIViewController {
        let viewModel = SportListViewModel(
            apiService: apiService,
            authService: authService,
            searchFilter: ContainsSportsSearchFiltering()
        )
        let viewController = SportListViewController(viewModel: viewModel)
        return viewController
    }
}
