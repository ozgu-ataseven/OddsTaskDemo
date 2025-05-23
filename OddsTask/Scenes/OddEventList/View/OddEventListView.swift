//
//  OddEventListView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//
 
import UIKit
import Combine

final class OddEventListView: UIView {

    // MARK: - Publishers
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private let selectionSubject = PassthroughSubject<OddEvent, Never>()
    
    var searchTextPublisher: AnyPublisher<String, Never> {
        searchTextSubject.eraseToAnyPublisher()
    }
    
    var selectionPublisher: AnyPublisher<OddEvent, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Views
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "odds_search".localized
        sb.searchBarStyle = .minimal
        sb.searchTextField.backgroundColor = OddsColor.fieldBackground
        sb.searchTextField.textColor = OddsColor.primaryLabelColor
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "odds_search".localized,
            attributes: [.foregroundColor: OddsColor.secondayLabelColor]
        )
        sb.searchTextField.layer.cornerRadius = 10
        sb.searchTextField.clipsToBounds = true
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(icon: UIImage(systemName: "questionmark.circle")!, message: "general_not_found".localized)
        view.isHidden = true
        return view
    }()

    // MARK: - Data
    private let dataSource = OddEventDataSource()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDelegates()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        fitSpecificLocation(subView: searchBar, anchors: [
            .top(safeAreaLayoutGuide.topAnchor),
            .left(leftAnchor, 16),
            .right(rightAnchor, -16)
        ])

        fitSpecificLocation(subView: tableView, anchors: [
            .top(searchBar.bottomAnchor, 12),
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(bottomAnchor)
        ])

        fitSpecificLocation(subView: emptyStateView, anchors: [
            .top(topAnchor),
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(bottomAnchor)
        ])
    }

    private func setupDelegates() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.register(OddEventCell.self, forCellReuseIdentifier: "OddEventCell")
        searchBar.delegate = self

        dataSource.selectionPublisher
            .sink { [weak self] event in
                self?.selectionSubject.send(event)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Interface
    func updateOddEvents(_ events: [OddEvent]) {
        tableView.isHidden = events.isEmpty
        emptyStateView.isHidden = !events.isEmpty
        dataSource.update(with: events)
        tableView.reloadData()
    }

    func updateEmptyState(isHidden: Bool) {
        emptyStateView.isHidden = isHidden
    }

    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UISearchBarDelegate

extension OddEventListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
}
