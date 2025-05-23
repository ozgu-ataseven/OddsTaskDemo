//
//  SportListView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
import Combine

final class SportListView: UIView {

    // MARK: - Publishers
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private let selectionSubject = PassthroughSubject<Sport, Never>()
    
    var searchTextPublisher: AnyPublisher<String, Never> {
        searchTextSubject.eraseToAnyPublisher()
    }
    
    var selectionPublisher: AnyPublisher<Sport, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Views
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "sports_search".localized
        sb.searchBarStyle = .minimal
        sb.searchTextField.backgroundColor = OddsColor.fieldBackground
        sb.searchTextField.textColor = OddsColor.primaryLabelColor
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "sports_search".localized,
            attributes: [.foregroundColor: OddsColor.secondayLabelColor]
        )
        sb.searchTextField.layer.cornerRadius = 10
        sb.searchTextField.clipsToBounds = true
        return sb
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = AdaptiveGridLayout()
        layout.delegate = self
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(SportCell.self)
        cv.subscribeKeyboardNotifies()
        return cv
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(icon: UIImage(systemName: "magnifyingglass.circle")!, message: "sports_no_result".localized)
        view.isHidden = true
        return view
    }()

    // MARK: - Data
    private let dataSource = SportDataSource()

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

        fitSpecificLocation(subView: collectionView, anchors: [
            .top(searchBar.bottomAnchor, 12),
            .left(leftAnchor, 16),
            .right(rightAnchor, -16),
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
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        searchBar.delegate = self
        
        dataSource.selectionPublisher
            .sink { [weak self] sport in
                self?.selectionSubject.send(sport)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Interface

    func updateSports(_ sports: [Sport]) {
        collectionView.isHidden = sports.isEmpty
        emptyStateView.isHidden = !sports.isEmpty
        dataSource.update(with: sports)
        collectionView.reloadData()
    }

    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UISearchBarDelegate

extension SportListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
}

// MARK: - AdaptiveGridLayoutDelegate

extension SportListView: AdaptiveGridLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        guard let sport = dataSource.item(at: indexPath) else { return 44 }
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingSize = CGSize(width: width - 16, height: .greatestFiniteMagnitude)
        let rect = (sport.title as NSString).boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(rect.height) + 16
    }
}
