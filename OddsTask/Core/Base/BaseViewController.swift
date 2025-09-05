//
//  BaseViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

class BaseViewController<RootView: UIView>: UIViewController, AlertPresentable {

    var rootView: RootView {
        guard let view = self.view as? RootView else {
            fatalError("Expected view of type \(RootView.self), got \(type(of: self.view)) instead")
        }
        return view
    }

    override func loadView() {
        self.view = RootView()
        view.backgroundColor = OddsColor.primaryColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    deinit {
        ProgressView.hide()
    }

    func setupLayout() {}
}
