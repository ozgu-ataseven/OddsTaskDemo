//
//  DependencyContainer.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation

public final class DependencyContainer {
    public let userDefaultsService: UserDefaultsServiceProtocol
    public let apiService: OddsAPIServiceProtocol
    public let authService: AuthenticationServiceProtocol
    public let analyticsService: AnalyticsServiceProtocol
    public let basketService: BasketServiceProtocol

    public init(
        userDefaultsService: UserDefaultsServiceProtocol,
        apiService: OddsAPIServiceProtocol,
        authService: AuthenticationServiceProtocol,
        analyticsService: AnalyticsServiceProtocol,
        basketService: BasketServiceProtocol
    ) {
        self.userDefaultsService = userDefaultsService
        self.apiService = apiService
        self.authService = authService
        self.analyticsService = analyticsService
        self.basketService = basketService
    }
}
