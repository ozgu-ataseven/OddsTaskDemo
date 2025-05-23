//
//  FirebaseAnalyticsService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 23.05.2025.
//

import FirebaseAnalytics

public protocol AnalyticsServiceProtocol {
    func logEvent(name: String, parameters: [String: Any]?)
    func logScreenView(screenName: String)
    func logUserProperty(name: String, value: String)
}

final class FirebaseAnalyticsService: AnalyticsServiceProtocol {
    func logEvent(name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }

    func logScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }

    func logUserProperty(name: String, value: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}
