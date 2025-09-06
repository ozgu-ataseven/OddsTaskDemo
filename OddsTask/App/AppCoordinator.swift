//
//  AppCoordinator.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 6.09.2025.
//

import UIKit

final class AppCoordinator {
    private let router: RouterProtocol
    private let factory: AppFactory
    private let firebaseService: FirebaseAuthServiceProtocol

    init(router: RouterProtocol, factory: AppFactory, firebaseService: FirebaseAuthServiceProtocol) {
        self.router = router
        self.factory = factory
        self.firebaseService = firebaseService
    }
    
    func makeInitialRootViewController() -> UIViewController {
        if firebaseService.isLoggedIn() {
            return factory.sportListViewController(router: router)
        } else {
            return factory.loginViewController(router: router)
        }
    }
}
