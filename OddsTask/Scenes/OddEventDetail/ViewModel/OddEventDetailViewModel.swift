//
//  OddEventDetailViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//
 
import Foundation
import Combine

final class OddEventDetailViewModel: OddEventDetailViewModelProtocol {

    // MARK: - Publishers
    private let detailSubject = PassthroughSubject<OddEventDetail, Never>()
    private let loadingSubject = PassthroughSubject<Bool, Never>()
    private let alertSubject = PassthroughSubject<Alert, Never>()
    private let basketRouteSubject = PassthroughSubject<Void, Never>()
    
    var sportKey: String
    var eventId: String

    var detailPublisher: AnyPublisher<OddEventDetail, Never> {
        detailSubject.eraseToAnyPublisher()
    }

    var loadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }

    var alertPublisher: AnyPublisher<Alert, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    
    var basketRoutePublisher: AnyPublisher<Void, Never> {
        basketRouteSubject.eraseToAnyPublisher()
    }

    // MARK: - Dependencies
    private let service: OddsAPIServiceProtocol
    private let basketService: BasketServiceProtocol
    private let authService: FirebaseAuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(
        apiService: OddsAPIServiceProtocol,
        basketService: BasketServiceProtocol,
        authService: FirebaseAuthServiceProtocol,
        sportKey: String,
        eventId: String
    ) {
        self.service = apiService
        self.basketService = basketService
        self.authService = authService
        self.sportKey = sportKey
        self.eventId = eventId
    }

    // MARK: - Fetch
    func fetchOddEventDetail() {
        loadingSubject.send(true)

        service.getOddEventDetail(sportKey: sportKey, eventId: eventId)
            .sink { [weak self] completion in
                self?.loadingSubject.send(false)
                if case .failure(let error) = completion {
                    self?.alertSubject.send(Alert(title: error.title, message: error.userMessage, actions: [.init(title: "general_done".localized)]))
                }
            } receiveValue: { [weak self] detail in
                guard let self else { return }
                self.detailSubject.send(detail)
            }
            .store(in: &cancellables)
    }
    
    func addBasket(item: BasketItem?) {
        guard let item = item,
            let userId = authService.getUserId()
        else { return }
        
        loadingSubject.send(true)
        basketService.addItem(item, for: userId) { [weak self] result in
            self?.loadingSubject.send(false)
            switch result {
            case .success:
                self?.basketRouteSubject.send(())
            case .failure(let error):
                self?.alertSubject.send(Alert(title: error.title, message: error.userMessage, actions: [.init(title: "Tamam")]))
            }
        }
    }
}
