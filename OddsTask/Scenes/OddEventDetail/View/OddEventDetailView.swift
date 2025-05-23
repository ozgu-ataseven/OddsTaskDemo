//
//  OddEventDetailView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit
import Combine

final class OddEventDetailView: UIView {

    // MARK: - Publishers
    private let selectionSubject = PassthroughSubject<BasketItem, Never>()
    var selectionPublisher: AnyPublisher<BasketItem, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = OddsColor.primaryLabelColor
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = OddsColor.secondayLabelColor
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .onDrag
        tv.register(OddEventDetailCell.self)
        return tv
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(icon: UIImage(systemName: "questionmark.circle")!, message: "odds_data_not_found".localized)
        view.isHidden = true
        return view
    }()

    // MARK: - Data
    private let dataSource = OddEventDetailDataSource()
    private var detail: OddEventDetail?

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
        fitSpecificLocation(subView: titleLabel, anchors: [
            .top(safeAreaLayoutGuide.topAnchor, 16),
            .left(leftAnchor, 16),
            .right(rightAnchor, -16)
        ])

        fitSpecificLocation(subView: timeLabel, anchors: [
            .top(titleLabel.bottomAnchor, 4),
            .left(leftAnchor, 16),
            .right(rightAnchor, -16)
        ])

        fitSpecificLocation(subView: tableView, anchors: [
            .top(timeLabel.bottomAnchor, 12),
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
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        dataSource.selectionPublisher
            .sink { [weak self] (outcome, marketKey, marketTitle, bookmakerTitle) in
                let item = BasketItem(
                    id: UUID().uuidString,
                    homeTeam: self?.detail?.homeTeam ?? "",
                    awayTeam: self?.detail?.awayTeam ?? "",
                    outcomeName: outcome.name,
                    price: outcome.price,
                    amount: outcome.price * 5,
                    bookmakerTitle: bookmakerTitle
                )
                self?.selectionSubject.send(item)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Interface

    func update(title: String, dateText: String) {
        titleLabel.text = title
        timeLabel.text = dateText
    }

    func updateData(_ detail: OddEventDetail) {
        self.detail = detail
        tableView.isHidden = detail.bookmakers.isEmpty
        emptyStateView.isHidden = !detail.bookmakers.isEmpty
        dataSource.update(with: detail.bookmakers)
        tableView.reloadData()
    }

    func updateEmptyState(isHidden: Bool) {
        emptyStateView.isHidden = isHidden
    }

    func reload() {
        tableView.reloadData()
    }

    // MARK: - Cleanup

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
