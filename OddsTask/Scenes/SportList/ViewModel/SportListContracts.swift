//
//  SportListContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation
import Combine

protocol SportListViewModelProtocol: AnyObject {
    var sportsPublisher: AnyPublisher<[Sport], Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var routeEventListPublisher: AnyPublisher<String, Never> { get }
    var routeLoginPublisher: AnyPublisher<Void, Never> { get }
    var searchText: String { get set }
    
    func fetchSports()
    func didSelectSport(_ sport: Sport)
    func logout()
}
