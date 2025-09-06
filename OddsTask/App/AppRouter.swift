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
    }
    
    func installRoot(_ viewController: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: viewController)
    }

    func push(_ route: Route, from source: UIViewController, animated: Bool = true) {
        guard let nav = navigationController, let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let targetVC = route.build(using: factory, router: self)
        DispatchQueue.main.async { [weak nav] in
            nav?.pushViewController(targetVC, animated: animated)
        }
    }
    
    func present(_ route: Route, from source: UIViewController, animated: Bool = true) {
        guard let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let targetVC = route.build(using: factory, router: self)
        DispatchQueue.main.async { [weak self] in
            if source.view.window != nil {
                source.present(targetVC, animated: animated)
            } else if let nav = self?.navigationController {
                nav.present(targetVC, animated: animated)
            } else {
                assertionFailure("No valid presenter found for route \(route).")
            }
        }
    }

    func setRoot(for route: Route, animated: Bool = true) {
        guard let nav = navigationController, let factory = appFactory else {
            assertionFailure("AppRouter not set up. Call setup(with:) first.")
            return
        }
        let viewController = route.build(using: factory, router: self)

        DispatchQueue.main.async { [weak nav] in
            if let presented = nav?.presentedViewController {
                presented.dismiss(animated: false)
            }

            let transition = CATransition()
            transition.duration = animated ? 0.3 : 0.0
            transition.type = .push
            transition.subtype = route.transitionSubtype
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            nav?.view.layer.add(transition, forKey: kCATransition)
            nav?.setViewControllers([viewController], animated: false)
        }
    }
    
    func navigationRootViewController() -> UIViewController {
        guard let nav = navigationController else {
            preconditionFailure("AppRouter not set up. Call setup(with:) before requesting the navigation root controller.")
        }
        return nav
    }
    
    func dismiss(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let presented = self?.navigationController?.presentedViewController else { return }
            presented.dismiss(animated: animated)
        }
    }
    
    func pop(animated: Bool = true) {
        DispatchQueue.main.async { [weak navigationController] in
            navigationController?.popViewController(animated: animated)
        }
    }
}
