//
//  OddEventDetailFactory.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 21.05.2025.
//

import UIKit

protocol OddEventDetailFactoryProtocol {
    func makeOddEventDetailViewController(sportKey: String, eventId: String) -> UIViewController
}

final class OddEventDetailFactory: OddEventDetailFactoryProtocol {
    private let dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func makeOddEventDetailViewController(
        sportKey: String,
        eventId: String
    ) -> UIViewController {
        let viewModel = OddEventDetailViewModel(
            dependencyContainer: dependencyContainer,
            sportKey: sportKey,
            eventId: eventId
        )
            
        let viewController = OddEventDetailViewController(viewModel: viewModel)
        return viewController
    }
}
