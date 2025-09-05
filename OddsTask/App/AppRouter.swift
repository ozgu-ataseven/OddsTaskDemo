//
//  AppRouter.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit


protocol RouterProtocol: AnyObject {
    func push(_ route: Route, from source: UIViewController, animated: Bool)
    func present(_ route: Route, from source: UIViewController, animated: Bool)
    func setRoot(for route: Route, animated: Bool)
    func dismiss(animated: Bool)
    func pop(animated: Bool)
}

final class AppRouter: RouterProtocol {
    static let shared = AppRouter()

    private(set) var navigationController: UINavigationController?
    private var appFactory: AppFactory?

    private init() { }

    func setup(with dependencyContainer: DependencyContainer) {
        let factory = AppFactory(dependencyContainer: dependencyContainer)
        self.appFactory = factory
        let initialVC = factory.initialViewController(router: self)
        self.navigationController = UINavigationController(rootViewController: initialVC)
    }

    func push(_ route: Route, from source: UIViewController, animated: Bool = true) {
        guard let nav = navigationController, let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let targetVC = route.build(using: factory, router: self)
        nav.pushViewController(targetVC, animated: animated)
    }
    
    func present(_ route: Route, from source: UIViewController, animated: Bool = true) {
        guard let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let targetVC = route.build(using: factory, router: self)
        source.present(targetVC, animated: animated)
    }

    func setRoot(for route: Route, animated: Bool = true) {
        guard let nav = navigationController, let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let viewController = route.build(using: factory, router: self)

        let transition = CATransition()
        transition.duration = animated ? 0.3 : 0.0
        transition.type = .push
        transition.subtype = route.transitionSubtype
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        nav.view.layer.add(transition, forKey: kCATransition)
        nav.setViewControllers([viewController], animated: false)
    }
    
    func navigationRootViewController() -> UIViewController {
        guard let nav = navigationController else {
            preconditionFailure("AppRouter not set up. Call setup(with:) before requesting the navigation root controller.")
        }
        return nav
    }
    
    func dismiss(animated: Bool = true) {
        guard let presentedViewController = navigationController?.presentedViewController else { return }
        presentedViewController.dismiss(animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}
