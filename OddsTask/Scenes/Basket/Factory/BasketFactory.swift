//
//  BasketFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import UIKit

protocol BasketFactoryProtocol {
    func makeBasketViewController() -> UIViewController
}

final class BasketFactory: BasketFactoryProtocol {
    private let authService: FirebaseAuthServiceProtocol
    private let basketService: BasketServiceProtocol

    init(authService: FirebaseAuthServiceProtocol, basketService: BasketServiceProtocol) {
        self.authService = authService
        self.basketService = basketService
    }

    func makeBasketViewController() -> UIViewController {
        let viewModel = BasketViewModel(authService: authService, basketService: basketService)
        let viewController = BasketViewController(viewModel: viewModel)
        return viewController
    }
}
