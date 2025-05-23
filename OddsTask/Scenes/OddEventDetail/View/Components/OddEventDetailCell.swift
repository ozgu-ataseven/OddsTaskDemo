//
//  OddEventDetailCell.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit
import Combine

final class OddEventDetailCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = OddsColor.activeFieldBorder
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let outcomeSelectedSubject = PassthroughSubject<(Outcome, String, String), Never>()
    var outcomeSelectedPublisher: AnyPublisher<(Outcome, String, String), Never> {
        outcomeSelectedSubject.eraseToAnyPublisher()
    }
    
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.fitSpecificLocation(subView: containerView, anchors: [
            .left(contentView.leftAnchor, 16),
            .right(contentView.rightAnchor, -16),
            .top(contentView.topAnchor),
            .bottom(contentView.bottomAnchor)
        ])
        
        containerView.fitSpecificLocation(subView: titleLabel, anchors: [
            .left(containerView.leftAnchor, 16),
            .right(containerView.rightAnchor, -16),
            .top(containerView.topAnchor, 12)
        ])
        
        containerView.fitSpecificLocation(subView: stackView, anchors: [
            .left(containerView.leftAnchor, 16),
            .right(containerView.rightAnchor, -16),
            .top(titleLabel.bottomAnchor, 8),
            .bottom(containerView.bottomAnchor, -12),
        ])
    }

    func configure(with bookmaker: Bookmaker) {
        titleLabel.text = bookmaker.title

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        var hasPublished = false
        
        bookmaker.markets.forEach { market in
            let marketView = MarketView()
            marketView.configure(with: market)
            stackView.addArrangedSubview(marketView)
            
            marketView.outcomeWithKeyPublisher
                .sink { [weak self] outcome, key in
                    guard let self = self else { return }
                    self.outcomeSelectedSubject.send((outcome, key, bookmaker.title))
                }
                .store(in: &cancellables)
        }
    }
}
