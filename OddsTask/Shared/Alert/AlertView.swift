//
//  AlertView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

public struct Alert: Equatable {
    let title: String
    let message: String
    let tintColor: UIColor?
    let actions: [AlertAction]

    public init(
        title: String,
        message: String,
        tintColor: UIColor? = nil,
        actions: [AlertAction]
    ) {
        self.title = title
        self.message = message
        self.tintColor = tintColor
        self.actions = actions
    }
}
