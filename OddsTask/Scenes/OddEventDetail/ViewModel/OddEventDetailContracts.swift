//
//  OddEventDetailContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import Foundation
import Combine

// MARK: - Coordinator Delegate Protocol

protocol OddEventDetailViewModelCoordinatorDelegate: AnyObject {
    func oddEventDetailViewModelDidAddToBasket()
}

// MARK: - ViewModel Protocol

protocol OddEventDetailViewModelProtocol {
    var detailPublisher: AnyPublisher<OddEventDetail, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var sportKey: String { get }
    var eventId: String { get }
    
    // MARK: - Coordinator Delegate
    var coordinatorDelegate: OddEventDetailViewModelCoordinatorDelegate? { get set }

    func fetchOddEventDetail()
    func addBasket(item: BasketItem?)
}
