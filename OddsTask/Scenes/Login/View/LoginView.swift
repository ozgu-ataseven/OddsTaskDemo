//
//  LoginView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit
import Combine

final class LoginView: UIView {

    // MARK: - Combine Outputs
    
    let loginTappedPublisher = PassthroughSubject<Void, Never>()
    let registerTappedPublisher = PassthroughSubject<Void, Never>()
    let emailChangedPublisher = PassthroughSubject<String, Never>()
    let passwordChangedPublisher = PassthroughSubject<String, Never>()

    // MARK: - UI Elements

    private let emailField: BaseTextField = {
        let tf = BaseTextField(placeholder: "general_email".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordField: BaseTextField = {
        let tf = BaseTextField(placeholder: "general_password".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let loginButton: BaseButton = {
        let btn = BaseButton(title: "login_button".localized)
        btn.setEnabled(false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("general_register".localized, for: .normal)
        btn.setTitleColor(OddsColor.linkText, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let infoLabel = BaseLabel(
        text: "login_reminder".localized,
        font: .systemFont(ofSize: 13)
    )

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(registerButton)

        loginButton.setHeight(50)

        fitSpecificLocation(subView: stackView, anchors: [
            .left(leftAnchor, 24),
            .right(rightAnchor, -24),
            .centerY(centerYAnchor)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        emailField.onTextChanged = { [weak self] text in
            self?.emailChangedPublisher.send(text)
        }

        passwordField.onTextChanged = { [weak self] text in
            self?.passwordChangedPublisher.send(text)
        }
    }

    // MARK: - Public Interface

    func showMailError(_ message: String?) {
        emailField.setError(message)
    }

    func showPasswordError(_ message: String?) {
        passwordField.setError(message)
    }

    func setLoginButton(enabled: Bool) {
        loginButton.setEnabled(enabled)
    }

    // MARK: - Button actions

    @objc private func loginTapped() {
        loginTappedPublisher.send()
    }

    @objc private func registerTapped() {
        registerTappedPublisher.send()
    }
}
