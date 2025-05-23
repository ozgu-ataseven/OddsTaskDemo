//
//  ProgressView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

enum ProgressView {
    private static var spinnerView: UIView?

    static func show(on view: UIView) {
        guard spinnerView == nil else { return }

        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = overlay.center
        indicator.startAnimating()

        overlay.addSubview(indicator)
        view.addSubview(overlay)

        spinnerView = overlay
    }

    static func hide() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
}
