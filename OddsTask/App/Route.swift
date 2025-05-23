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

    func build(using factory: AppFactory) -> UIViewController {
        switch self {
        case .login:
            return factory.loginViewController()
        case .register:
            return factory.registerViewController()
        case .sportList:
            return factory.sportListViewController()
        case .oddEventList(let sportKey):
            return factory.oddListViewController(sportKey: sportKey)
        case .oddEventDetail(sportKey: let sportKey, eventId: let eventId):
            return factory.oddEventDetailViewController(sportKey: sportKey, eventId: eventId)
        case .basket:
            return factory.basketViewController()
        }
    }
}
