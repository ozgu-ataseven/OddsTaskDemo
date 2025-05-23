//
//  BasketViewCell.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import UIKit

final class BasketViewCell: UITableViewCell {

    private let matchLabel = UILabel()
    private let selectionLabel = UILabel()
    private let oddLabel = UILabel()
    private let priceLabel = UILabel()
    private let totalLabel = UILabel()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 46/255, alpha: 1)

        matchLabel.font = .boldSystemFont(ofSize: 15)
        matchLabel.textColor = .white
        selectionLabel.font = .systemFont(ofSize: 14)
        selectionLabel.textColor = .lightGray
        oddLabel.font = .systemFont(ofSize: 14)
        oddLabel.textColor = .systemYellow
        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .systemTeal
        totalLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        totalLabel.textColor = .systemGreen

        [matchLabel, selectionLabel, oddLabel, priceLabel, totalLabel].forEach {
            stackView.addArrangedSubview($0)
        }

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with item: BasketItem) {
        matchLabel.text = "🏟️ \(item.homeTeam) vs \(item.awayTeam)"
        selectionLabel.text = "🎯 Seçim: \(item.outcomeName) - \(item.bookmakerTitle)"
        oddLabel.text = "📈 Oran: \(String(format: "%.2f", item.price))"
        priceLabel.text = "💰 Tutar: \(String(format: "%.2f", item.amount ?? 0))₺"
        totalLabel.text = "🧮 Toplam: \(String(format: "%.2f", (item.amount ?? 0) * item.price))₺"
    }
}
