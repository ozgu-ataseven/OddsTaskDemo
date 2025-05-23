//
//  MarketViewCollectionViewCell.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 21.05.2025.
//

import UIKit

final class MarketViewCollectionViewCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textColor = .systemGreen
        priceLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.backgroundColor = .darkGray
    }

    func configure(with outcome: Outcome) {
        nameLabel.text = outcome.name
        priceLabel.text = String(format: "%.2f", outcome.price)
    }
}
