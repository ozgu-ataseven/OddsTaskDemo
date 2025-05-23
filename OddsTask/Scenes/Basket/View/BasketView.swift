//
//  BasketView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//
 
import UIKit
import Combine 

final class BasketView: UIView {

    // MARK: - Views

    private let closeButton = UIButton(type: .system)
    private let tableView = UITableView()
    private let emptyStateView = EmptyStateView()
    private let bottomBar = BasketBottomBarView()

    // MARK: - Combine

    private let closeTappedSubject = PassthroughSubject<Void, Never>()
    private let clearAllTappedSubject = PassthroughSubject<Void, Never>()
    private let playTappedSubject = PassthroughSubject<Void, Never>()

    var closeTappedPublisher: AnyPublisher<Void, Never> {
        closeTappedSubject.eraseToAnyPublisher()
    }

    var clearAllTappedPublisher: AnyPublisher<Void, Never> {
        clearAllTappedSubject.eraseToAnyPublisher()
    }

    var playTappedPublisher: AnyPublisher<Void, Never> {
        playTappedSubject.eraseToAnyPublisher()
    }

    // MARK: - Data

    private let dataSource = BasketDataSource()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = OddsColor.primaryLabelColor

        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BasketViewCell.self)
        tableView.dataSource = dataSource

        emptyStateView.configure(icon: UIImage(systemName: "cart")!, message: "Sepetiniz boş.")
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        addSubview(closeButton)
        addSubview(tableView)
        addSubview(emptyStateView)
        addSubview(bottomBar)

        fitSpecificLocation(subView: closeButton, anchors: [
            .top(safeAreaLayoutGuide.topAnchor, 12),
            .right(rightAnchor, -16)
        ])
        closeButton.setHeight(28)
        closeButton.setWidth(28)

        fitSpecificLocation(subView: bottomBar, anchors: [
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(safeAreaLayoutGuide.bottomAnchor)
        ])

        fitSpecificLocation(subView: tableView, anchors: [
            .top(closeButton.bottomAnchor, 12),
            .left(leftAnchor, 16),
            .right(rightAnchor, -16),
            .bottom(bottomBar.topAnchor, -12)
        ])

        fitSpecificLocation(subView: emptyStateView, anchors: [
            .top(closeButton.bottomAnchor, 12),
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(bottomBar.topAnchor, -12)
        ])
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        bottomBar.clearAllButton.addTarget(self, action: #selector(clearAllTapped), for: .touchUpInside)
        bottomBar.playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        closeTappedSubject.send(())
    }

    @objc private func clearAllTapped() {
        clearAllTappedSubject.send(())
    }

    @objc private func playTapped() {
        playTappedSubject.send(())
    }

    // MARK: - Public Interface

    func updateItems(_ items: [BasketItem]) {
        tableView.isHidden = items.isEmpty
        emptyStateView.isHidden = !items.isEmpty
        dataSource.update(with: items)
        tableView.reloadData()
    }

    func updateTotalPrice(_ total: Double, amount: Double) {
        bottomBar.configure(totalAmount: amount, totalWinning: total)
    }

    func setDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    func deleteRow(at indexPath: IndexPath) {
        dataSource.remove(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func item(at indexPath: IndexPath) -> BasketItem? {
        return dataSource.item(at: indexPath)
    }
}
