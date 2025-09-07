//
//  SportListViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit
import Combine

final class SportListViewController: BaseViewController<SportListView> {

    private let viewModel: SportListViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SportListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "sports_all".localized
        configureNavigationBar()
        bindViewModel()
        bindView()
        viewModel.fetchSports()
    }

    private func configureNavigationBar() {
        let basketButton = UIBarButtonItem(
            image: UIImage(systemName: "cart.fill"),
            style: .plain,
            target: self,
            action: #selector(basketTapped)
        )
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        navigationItem.rightBarButtonItems = [logoutButton, basketButton]
    }

    @objc private func basketTapped() {
        viewModel.basketTapped()
    }

    @objc private func logoutTapped() {
        viewModel.logout()
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

        viewModel.sportsPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] sports in
                self?.rootView.updateSports(sports)
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
            .sink { [weak self] sport in
                self?.viewModel.didSelectSport(sport)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
