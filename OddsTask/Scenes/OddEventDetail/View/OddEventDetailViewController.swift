//
//  OddEventDetailViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit
import Combine

final class OddEventDetailViewController: BaseViewController<OddEventDetailView> {

    // MARK: - Properties
    private let viewModel: OddEventDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: OddEventDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "event_title".localized
        bindViewModel()
        bindView()
        viewModel.fetchOddEventDetail()
    }

    // MARK: - Bindings
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

        viewModel.detailPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] detail in
                self?.rootView.updateData(detail)
            }
            .store(in: &cancellables)
        
    }

    private func bindView() {
        rootView.selectionPublisher
            .sink { [weak self] basketItem in
                self?.viewModel.addBasket(item: basketItem)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
