//
//  OddEventCell.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit

final class OddEventCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = OddsColor.activeFieldBorder
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = OddsColor.primaryColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = OddsColor.secondayLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        contentView.fitSpecificLocation(subView: containerView, anchors: [
            .top(contentView.topAnchor, 8),
            .left(contentView.leftAnchor, 16),
            .right(contentView.rightAnchor, -16),
            .bottom(contentView.bottomAnchor, -8)
        ])

        containerView.fitSpecificLocation(subView: titleLabel, anchors: [
            .top(containerView.topAnchor, 8),
            .left(containerView.leftAnchor, 12),
            .right(containerView.rightAnchor, -12)
        ])

        containerView.fitSpecificLocation(subView: timeLabel, anchors: [
            .top(titleLabel.bottomAnchor, 4),
            .left(titleLabel.leftAnchor),
            .right(titleLabel.rightAnchor),
            .bottom(containerView.bottomAnchor, -8)
        ])
    }

    // MARK: - Configure
    func configure(with event: OddEvent) {
        titleLabel.text = "\(event.homeTeam ?? "Ev Sahibi") vs \(event.awayTeam ?? "Deplasman")"
        timeLabel.text = event.commenceTime.toFormattedDateString()
    }
}
