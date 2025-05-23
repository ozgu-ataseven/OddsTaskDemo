//
//  SportCell.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit

final class SportCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = OddsColor.primaryColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = OddsColor.activeFieldBorder
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        contentView.fitSpecificLocation(subView: titleLabel, anchors: [
            .top(contentView.topAnchor, 8),
            .left(contentView.leftAnchor, 8),
            .right(contentView.rightAnchor, -8),
            .bottom(contentView.bottomAnchor, -8)
        ])
    }

    func configure(with sport: Sport) {
        titleLabel.text = sport.title
    }
}
