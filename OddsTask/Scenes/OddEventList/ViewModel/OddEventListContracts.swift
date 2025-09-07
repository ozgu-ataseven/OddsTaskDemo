//
//  OddEventListContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation
import Combine

protocol OddEventListViewModelCoordinatorDelegate: AnyObject {
    func oddEventListViewModelDidSelectEvent(sportKey: String, eventId: String)
}

protocol OddEventListViewModelProtocol: AnyObject {
    // MARK: - Input Properties
    var searchText: String { get set }
    
    // MARK: - Output Publishers
    var oddEventsPublisher: AnyPublisher<[OddEvent], Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    
    // MARK: - Coordinator Delegate
    var coordinatorDelegate: OddEventListViewModelCoordinatorDelegate? { get set }
    
    // MARK: - Actions
    func fetchOdds()
    func didSelectEvent(_ event: OddEvent)
}
