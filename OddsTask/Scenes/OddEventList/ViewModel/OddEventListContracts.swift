//
//  OddEventListContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
import Combine

protocol OddEventListViewModelProtocol: AnyObject {
    var oddEventsPublisher: AnyPublisher<[OddEvent], Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }

    var searchText: String { get set }

    func fetchOdds()
    func didSelectEvent(_ event: OddEvent)
    var routePublisher: AnyPublisher<(sportKey: String, eventId: String), Never> { get }
}
