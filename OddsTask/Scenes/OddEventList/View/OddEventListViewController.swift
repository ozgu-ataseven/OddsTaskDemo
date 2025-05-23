//
//  OddEventListViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
import Combine

final class OddEventListViewController: BaseViewController<OddEventListView> {

    private let viewModel: OddEventListViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: OddEventListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "odds_title".localized
        bindViewModel()
        bindView()
        viewModel.fetchOdds()
    }

    private func bindViewModel() {
        viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? ProgressView.show(on: self.view) : ProgressView.hide()
            }
            .store(in: &cancellables)

        viewModel.alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                self?.showAlert(alert)
            }
            .store(in: &cancellables)

        viewModel.oddEventsPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] odds in
                self?.rootView.updateOddEvents(odds)
            }
            .store(in: &cancellables)
        
        
        viewModel.routePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] sportKey, eventId  in
                guard let self else { return }
                AppRouter.shared.push(.oddEventDetail(sportKey: sportKey, eventId: eventId), from: self)
            }
            .store(in: &cancellables)
    }
    
    private func bindView() {
        rootView.searchTextPublisher
            .removeDuplicates()
            .sink { [weak self] query in
                self?.viewModel.searchText = query
            }
            .store(in: &cancellables)
        
        rootView.selectionPublisher
            .sink { [weak self] event in
                self?.viewModel.didSelectEvent(event)
            }
            .store(in: &cancellables)
    }
}
