//
//  AlertPresentable.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

public protocol AlertPresentable where Self: UIViewController {
    func showAlert(_ alert: Alert, style: UIAlertController.Style)
    func showMessage(title: String, message: String, buttonTitle: String)
}

extension AlertPresentable {
    public func showAlert(
        _ alert: Alert,
        style: UIAlertController.Style = .alert
    ) {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: style
        )

        alert.actions.forEach { (action) in
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { _ in action.action() }
            )
            alertController.addAction(alertAction)
            if action.isPreffered {
                alertController.preferredAction = alertAction
            }
        }

        if let color = alert.tintColor {
            alertController.view.tintColor = color
        }

        present(alertController, animated: true)
    }

    public func showMessage(title: String, message: String, buttonTitle: String) {
        let defaultAction = AlertAction(title: buttonTitle)
        let alert = Alert(title: title, message: message, actions: [defaultAction])
        showAlert(alert)
    }
}
