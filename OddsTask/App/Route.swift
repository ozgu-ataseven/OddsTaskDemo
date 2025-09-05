//
//  Route.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit

enum Route {
    case login
    case register
    case sportList
    case oddEventList(sportKey: String)
    case oddEventDetail(sportKey: String, eventId: String)
    case basket

    var transitionSubtype: CATransitionSubtype {
        switch self {
        case .login:
            return .fromLeft
        default:
            return .fromRight
        }
    }

    func build(using factory: AppFactory, router: RouterProtocol) -> UIViewController {
        switch self {
        case .login:
            return factory.loginViewController(router: router)
        case .register:
            return factory.registerViewController(router: router)
        case .sportList:
            return factory.sportListViewController(router: router)
        case .oddEventList(let sportKey):
            return factory.oddListViewController(sportKey: sportKey, router: router)
        case .oddEventDetail(let sportKey, let eventId):
            return factory.oddEventDetailViewController(sportKey: sportKey, eventId: eventId, router: router)
        case .basket:
            return factory.basketViewController(router: router)
        }
    }
}
