//
//  OddEventDetailFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 21.05.2025.
//

import UIKit

protocol OddEventDetailFactoryProtocol {
    func makeOddEventDetailViewController(sportKey: String, eventId: String) -> UIViewController
}

final class OddEventDetailFactory: OddEventDetailFactoryProtocol {
    private let apiService: OddsAPIServiceProtocol
    private let authService: AuthenticationServiceProtocol
    private let basketService: BasketServiceProtocol
    private let router: RouterProtocol

    init(apiService: OddsAPIServiceProtocol, authService: AuthenticationServiceProtocol, basketService: BasketServiceProtocol, router: RouterProtocol) {
        self.apiService = apiService
        self.authService = authService
        self.basketService = basketService
        self.router = router
    }

    func makeOddEventDetailViewController(
        sportKey: String,
        eventId: String
    ) -> UIViewController {
        let viewModel = OddEventDetailViewModel(
            apiService: apiService,
            basketService: basketService,
            authService: authService,
            sportKey: sportKey,
            eventId: eventId
        )
        let viewController = OddEventDetailViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
