//
//  ScrollView+Extensions.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit

extension UIScrollView {

    func subscribeKeyboardNotifies() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowed),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHided),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unsubscribeKeyboardNotifies() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShowed(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let bottomInset = keyboardHeight - safeAreaInsets.bottom

        contentInset.bottom = bottomInset
        verticalScrollIndicatorInsets.bottom = bottomInset
    }

    @objc private func keyboardWillHided(_ notification: Notification) {
        contentInset.bottom = 0
        verticalScrollIndicatorInsets.bottom = 0
    }
}
