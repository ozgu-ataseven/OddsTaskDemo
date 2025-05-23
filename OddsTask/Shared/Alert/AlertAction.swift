//
//  AlertAction.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

public struct AlertAction: Equatable {
    let title: String
    let style: UIAlertAction.Style
    let action: () -> Void?
    let isPreffered: Bool

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        isPreffered: Bool = false,
        action: @autoclosure @escaping () -> Void? = nil
    ) {
        self.style = style
        self.title = title
        self.action = action
        self.isPreffered = isPreffered
    }

    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        return lhs.title == rhs.title
    }
}
