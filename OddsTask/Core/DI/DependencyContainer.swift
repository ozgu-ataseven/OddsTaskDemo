//
//  DependencyContainer.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation

public final class DependencyContainer {
    public let userDefaultsService: UserDefaultsServiceProtocol

    public init(
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.userDefaultsService = userDefaultsService
    }
}
