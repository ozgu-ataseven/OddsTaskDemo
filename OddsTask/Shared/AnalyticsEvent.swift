//
//  AnalyticsEvent.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 23.05.2025.
//

import Foundation

enum AnalyticsEvent {
    enum Screen {
        static let login = "login_screen"
        static let register = "register_screen"
    }

    enum Action {
        static let loginTapped = "login_tapped"
        static let registerTapped = "register_tapped"
        static let logoutTapped = "logout_tapped"
        static let openBasket = "open_basket"
        static let selectSport = "select_sport"
    }

    enum Error {
        static let loginFailed = "login_failed"
        static let registrationFailed = "registration_failed"
    }
}
