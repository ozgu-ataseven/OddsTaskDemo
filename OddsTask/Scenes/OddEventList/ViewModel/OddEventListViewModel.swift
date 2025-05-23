//
//  OddEventListViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Combine

final class OddEventListViewModel: OddEventListViewModelProtocol {
    
    // MARK: - Publishers
    @Published private var odds: [OddEvent] = []
    @Published var searchText: String = ""
    
    var oddEventsPublisher: AnyPublisher<[OddEvent], Never> {
        $filteredOdds.eraseToAnyPublisher()
    }

    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    var alertPublisher: AnyPublisher<Alert, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    
    private let routeSubject = PassthroughSubject<(sportKey: String, eventId: String), Never>()

    var routePublisher: AnyPublisher<(sportKey: String, eventId: String), Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    func didSelectEvent(_ event: OddEvent) {
        routeSubject.send((sportKey: event.sportKey, eventId: event.id))
    }

    // MARK: - Dependencies
    private let sportKey: String
    private let service: OddsAPIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    @Published private var filteredOdds: [OddEvent] = []
    @Published private var isLoading: Bool = false
    private let alertSubject = PassthroughSubject<Alert, Never>()

    // MARK: - Init
    init(dependencyContainer: DependencyContainer, sportKey: String) {
        self.sportKey = sportKey
        self.service = dependencyContainer.apiService
        bindSearch()
    }

    // MARK: - Public Methods
    func fetchOdds() {
        isLoading = true
        service.getOddEvents(for: sportKey)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.alertSubject.send(Alert(title: "Hata", message: error.localizedDescription, actions: [.init(title: "Tamam")]))
                }
            }, receiveValue: { [weak self] odd in
                guard let self else { return }
                
                let hasMissingTeams = odd.contains { $0.homeTeam == nil || $0.awayTeam == nil }
                if hasMissingTeams {
                    presentMissingTeamAlert()
                    return
                }
                
                self.odds = odd
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func bindSearch() {
        $searchText
            .combineLatest($odds)
            .map { searchText, odds in
                guard !searchText.isEmpty else { return odds }
                let query = searchText.lowercased()

                return odds.filter { item in
                    let home = item.homeTeam?.lowercased() ?? ""
                    let away = item.awayTeam?.lowercased() ?? ""
                    return home.contains(query) || away.contains(query)
                }
            }
            .assign(to: &$filteredOdds)
    }
    
    private func presentMissingTeamAlert() {

        let alertAction = AlertAction(
            title: "Tamam",
            action: AppRouter.shared.pop()
        )
        
        let alert = Alert(
                title: "Eksik Veri",
                message: "Etkinliklerden bazıları eksik takım bilgisi içeriyor. Lütfen tekrar deneyin.",
                actions: [alertAction]
            )
        
        alertSubject.send(alert)
    }
}
