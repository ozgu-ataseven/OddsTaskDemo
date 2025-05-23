//
//  BaseLabel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//
 
import UIKit

final class BaseLabel: UILabel {
    init(text: String? = nil, font: UIFont = .systemFont(ofSize: 13), color: UIColor? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = color ?? OddsColor.primaryLabelColor
        self.font = font
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
