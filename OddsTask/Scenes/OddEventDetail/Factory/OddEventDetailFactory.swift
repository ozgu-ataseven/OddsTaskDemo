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
    private let authService: FirebaseAuthServiceProtocol
    private let basketService: BasketServiceProtocol

    init(
        apiService: OddsAPIServiceProtocol,
        authService: FirebaseAuthServiceProtocol,
        basketService: BasketServiceProtocol
    ) {
        self.apiService = apiService
        self.authService = authService
        self.basketService = basketService
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
        let viewController = OddEventDetailViewController(viewModel: viewModel)
        return viewController
    }
}
