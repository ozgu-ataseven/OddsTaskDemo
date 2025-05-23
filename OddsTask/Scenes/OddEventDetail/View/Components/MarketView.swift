//
//  MarketView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 21.05.2025.
//

import UIKit
import Combine

final class MarketView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(MarketViewCollectionViewCell.self)
        cv.dataSource = collectionViewDataSource
        cv.delegate = collectionViewDataSource
        return cv
    }()

    private let collectionViewDataSource = MarketViewCollectionViewDataSource()
    private let outcomeWithKeySubject = PassthroughSubject<(Outcome, String), Never>()
    var outcomeWithKeyPublisher: AnyPublisher<(Outcome, String), Never> {
        outcomeWithKeySubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindSelection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, collectionView])
        stack.axis = .vertical
        stack.spacing = 8
        
        fitToArea(subView: stack)
        collectionView.setHeight(60)
    }

    func configure(with market: Market) {
        titleLabel.text = market.key.uppercased()
        collectionViewDataSource.update(with: market.outcomes)
        collectionView.reloadData()
    }

    private func bindSelection() {
        collectionViewDataSource.outcomeSelectedPublisher
            .sink { [weak self] outcome in
                guard let self else { return }
                let key = self.titleLabel.text?.lowercased() ?? ""
                self.outcomeWithKeySubject.send((outcome, key))
            }
            .store(in: &cancellables)
    }
}
