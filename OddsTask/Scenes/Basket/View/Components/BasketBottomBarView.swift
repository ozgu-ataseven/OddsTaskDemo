//
//  BasketBottomBarView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import UIKit

final class BasketBottomBarView: UIView {

    private let totalAmountLabel = UILabel()
    private let totalWinningLabel = UILabel()

    let clearAllButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        totalAmountLabel.font = .systemFont(ofSize: 14)
        totalAmountLabel.textColor = .white

        totalWinningLabel.font = .boldSystemFont(ofSize: 14)
        totalWinningLabel.textColor = .green

        clearAllButton.setTitle("Tümünü Sil", for: .normal)
        clearAllButton.setTitleColor(.red, for: .normal)

        playButton.setTitle("Oyna", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = UIColor.systemGreen
        playButton.layer.cornerRadius = 8
        playButton.titleLabel?.font = .boldSystemFont(ofSize: 15)

        let labelStack = UIStackView(arrangedSubviews: [totalAmountLabel, totalWinningLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4

        let buttonStack = UIStackView(arrangedSubviews: [clearAllButton, playButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let mainStack = UIStackView(arrangedSubviews: [labelStack, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func configure(totalAmount: Double, totalWinning: Double) {
        totalAmountLabel.text = "Toplam Tutar: ₺" + String(format: "%.2f", totalAmount)
        totalWinningLabel.text = "Beklenen Kazanç: ₺" + String(format: "%.2f", totalWinning)
    }
}
