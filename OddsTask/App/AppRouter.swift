//
//  AppRouter.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit


final class AppRouter {

    static let shared = AppRouter()

    private(set) var navigationController: UINavigationController!
    private var appFactory: AppFactory!

    private init() { }

    func setup(with dependencyContainer: DependencyContainer) {
        appFactory = AppFactory(dependencyContainer: dependencyContainer)
        let initialVC = appFactory.initialViewController()
        navigationController = UINavigationController(rootViewController: initialVC)
    }

    func push(_ route: Route, from source: UIViewController, animated: Bool = true) {
        let targetVC = route.build(using: appFactory)
        source.navigationController?.pushViewController(targetVC, animated: animated)
    }
    
    func present(_ route: Route, from source: UIViewController, animated: Bool = true) {
        let targetVC = route.build(using: appFactory)
        source.navigationController?.present(targetVC, animated: animated)
    }

    func setRoot(for route: Route, animated: Bool = true) {
        let viewController = route.build(using: appFactory)

        let transition = CATransition()
        transition.duration = animated ? 0.3 : 0.0
        transition.type = .push
        transition.subtype = route.transitionSubtype
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func navigationRootViewController() -> UIViewController {
        return navigationController
    }
    
    func dismiss(animated: Bool = true) {
        guard let presentedViewController = navigationController?.presentedViewController else {
            return
        }
        presentedViewController.dismiss(animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
