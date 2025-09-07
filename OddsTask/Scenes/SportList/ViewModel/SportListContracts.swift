//
//  SportListContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation
import Combine

// MARK: - Coordinator Delegate Protocol

protocol SportListViewModelCoordinatorDelegate: AnyObject {
    func sportListViewModelDidSelectSport(sportKey: String)
    func sportListViewModelDidRequestLogout()
    func sportListViewModelDidRequestBasket()
}

// MARK: - ViewModel Protocol

protocol SportListViewModelProtocol: AnyObject {
    var sportsPublisher: AnyPublisher<[Sport], Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var searchText: String { get set }
    
    // MARK: - Coordinator Delegate
    var coordinatorDelegate: SportListViewModelCoordinatorDelegate? { get set }
    
    func fetchSports()
    func didSelectSport(_ sport: Sport)
    func logout()
    func basketTapped()
}
