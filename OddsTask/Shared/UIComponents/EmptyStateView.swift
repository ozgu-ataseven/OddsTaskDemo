//
//  EmptyView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit

final class EmptyStateView: UIView {

    // MARK: - UI Elements

    private let containerView = UIView()
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = OddsColor.primaryColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = OddsColor.secondayLabelColor
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        fitSpecificLocation(subView: containerView, anchors: [
            .centerX(centerXAnchor),
            .centerY(centerYAnchor)
        ])

        containerView.fitSpecificLocation(subView: iconView, anchors: [
            .top(containerView.topAnchor),
            .centerX(containerView.centerXAnchor),
            .width(60),
            .height(60)
        ])

        containerView.fitSpecificLocation(subView: messageLabel, anchors: [
            .top(iconView.bottomAnchor, 12),
            .left(containerView.leftAnchor, 16),
            .right(containerView.rightAnchor, -16),
            .bottom(containerView.bottomAnchor)
        ])
    }

    // MARK: - Public

    func configure(icon: UIImage?, message: String) {
        iconView.image = icon
        iconView.tintColor = OddsColor.activeFieldBorder
        messageLabel.text = message
    }
}
