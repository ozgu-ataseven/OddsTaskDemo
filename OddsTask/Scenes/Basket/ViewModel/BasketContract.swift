//
//  BasketContract.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import Foundation
import Combine

// MARK: - ViewModel Protocol

protocol BasketViewModelProtocol {
    var itemsPublisher: AnyPublisher<[BasketItem], Never> { get }
    var totalPricePublisher: AnyPublisher<Double, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var totalAmountPublisher: AnyPublisher<Double, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }

    func fetchBasketItems()
    func removeItem(withId id: String)
    func clearBasket()
}

// MARK: - View Protocol

protocol BasketViewProtocol: AnyObject {
    func updateItems(_ items: [BasketItem])
    func updateTotalPrice(_ total: Double)
    func showAlert(_ alert: Alert)
}
