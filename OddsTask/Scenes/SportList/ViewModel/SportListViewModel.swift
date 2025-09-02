//
//  SportListViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation
import Combine

final class SportListViewModel: SportListViewModelProtocol {
    
    private let service: OddsAPIServiceProtocol
    private let authService: AuthenticationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let routeLoginSubject = PassthroughSubject<Void, Never>()
    
    @Published private var sports: [Sport] = []
    @Published private var isLoading: Bool = false
    @Published private var alert: Alert?
    @Published var searchText: String = ""
    @Published private(set) var filteredSports: [Sport] = []
    @Published private var selectedSportKey: String? = nil
    
    var sportsPublisher: AnyPublisher<[Sport], Never> {
        $filteredSports.eraseToAnyPublisher()
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var alertPublisher: AnyPublisher<Alert, Never> {
        $alert.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    var routeEventListPublisher: AnyPublisher<String, Never> {
        $selectedSportKey
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    var routeLoginPublisher: AnyPublisher<Void, Never> {
        routeLoginSubject.eraseToAnyPublisher()
    }
    
    init(apiService: OddsAPIServiceProtocol, authService: AuthenticationServiceProtocol) {
        self.service = apiService
        self.authService = authService
        bindSearch()
    }
    
    func fetchSports() {
        isLoading = true
        service.getAllSports()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alert = Alert(title: "general_error".localized, message: error.localizedDescription, actions: [.init(title: "general_done".localized)])
                }
            } receiveValue: { [weak self] sports in
                self?.sports = sports
            }
            .store(in: &cancellables)
    }
    
    func didSelectSport(_ sport: Sport) {
        selectedSportKey = sport.key
    }
    
    func logout() {
        switch authService.signOut() {
        case .success:
            routeLoginSubject.send()
        case .failure(let error):
            self.alert = Alert(
                title: "Çıkış Başarısız",
                message: error.localizedDescription,
                actions: [.init(title: "Tamam")]
            )
        }
    }
    
    // MARK: - Private Methods
    private func bindSearch() {
        $searchText
            .combineLatest($sports)
            .map { query, allSports in
                guard !query.isEmpty else { return allSports }
                return allSports.filter { $0.title.lowercased().contains(query.lowercased()) }
            }
            .assign(to: \.filteredSports, on: self)
            .store(in: &cancellables)
    }
}
