//
//  OddEventDetailContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import Foundation
import Combine

protocol OddEventDetailViewModelProtocol {
    var detailPublisher: AnyPublisher<OddEventDetail, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var basketRoutePublisher: AnyPublisher<Void, Never> { get }
    var sportKey: String { get }
    var eventId: String { get }

    func fetchOddEventDetail()
    func addBasket(item: BasketItem?)
}
