//
//  BasketViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import Foundation
import Combine

final class BasketViewModel: BasketViewModelProtocol {
    
    @Published private var isLoading: Bool = false
    
    private let basketService: BasketServiceProtocol
    private let authService: AuthenticationServiceProtocol
    
    // MARK: - Subjects
    private let itemsSubject = CurrentValueSubject<[BasketItem], Never>([])
    private let totalPriceSubject = CurrentValueSubject<Double, Never>(0)
    private let alertSubject = PassthroughSubject<Alert, Never>()
    private let totalAmountSubject = CurrentValueSubject<Double, Never>(0)
    
    // MARK: - Public Publishers
    var itemsPublisher: AnyPublisher<[BasketItem], Never> {
        itemsSubject.eraseToAnyPublisher()
    }
    
    var totalPricePublisher: AnyPublisher<Double, Never> {
        totalPriceSubject.eraseToAnyPublisher()
    }
    
    var alertPublisher: AnyPublisher<Alert, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    
    var totalAmountPublisher: AnyPublisher<Double, Never> {
        totalAmountSubject.eraseToAnyPublisher()
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    // MARK: - Internal State
    private var basketItems: [BasketItem] = []
    
    // MARK: - Init
    init(
        authService: AuthenticationServiceProtocol,
        basketService: BasketServiceProtocol
    ) {
        self.basketService = basketService
        self.authService = authService
        fetchBasketItems()
    }
    
    // MARK: - Public Actions
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBasketItems() {
        guard let userId = authService.getUserId() else {
            return
        }
        
        isLoading = true
        basketService.fetchItems(for: userId, completion: { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            if case let .failure(error) = result {
                let alert = Alert(title: "Error", message: error.localizedDescription, actions: [.init(title: "Tamam")])
                alertSubject.send(alert)
                return
            }
            
            if case let .success(items) = result {
                self.basketItems = items
                self.publish()
            }
        })
    }
    
    func removeItem(withId id: String) {
        guard let userId = authService.getUserId() else { return }
        
        isLoading = true
        basketService.removeItem(itemId: id, for: userId) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success:
                self.basketItems.removeAll { $0.id == id }
                self.publish()
            case .failure(let error):
                let alert = Alert(title: "Error", message: error.localizedDescription, actions: [.init(title: "Tamam")])
                self.alertSubject.send(alert)
            }
        }
    }
    
    func clearBasket() {
        guard let userId = authService.getUserId() else { return }
        
        isLoading = true
        basketService.clearBasket(for: userId) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success:
                self.fetchBasketItems()
            case .failure(let error):
                let alert = Alert(title: "Error", message: error.localizedDescription, actions: [.init(title: "Tamam")])
                self.alertSubject.send(alert)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func publish() {
        itemsSubject.send(basketItems)
        let total = basketItems.map { $0.price * ($0.amount ?? 0) }.reduce(0, +)
        let amount = basketItems.map { $0.amount ?? 0 }.reduce(0, +)
        totalPriceSubject.send(total)
        totalAmountSubject.send(amount)
    }
}
