//
//  RegisterView.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit
import Combine

final class RegisterView: UIView {

    // MARK: - Combine Outputs
    
    let nameChangedPublisher = PassthroughSubject<String, Never>()
    let emailChangedPublisher = PassthroughSubject<String, Never>()
    let passwordChangedPublisher = PassthroughSubject<String, Never>()
    let confirmPasswordChangedPublisher = PassthroughSubject<String, Never>()
    let termsAcceptedPublisher = PassthroughSubject<Bool, Never>()
    let registerTappedPublisher = PassthroughSubject<Void, Never>()

    // MARK: - UI Elements
    
    private(set) var nameField: BaseTextField = {
        let tf = BaseTextField(placeholder: "register_name".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private(set) var emailField: BaseTextField = {
        let tf = BaseTextField(placeholder: "general_email".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private(set) var passwordField: BaseTextField = {
        let tf = BaseTextField(placeholder: "general_password".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private(set) var confirmPasswordField: BaseTextField = {
        let tf = BaseTextField(placeholder: "general_confirm_password".localized)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let termsSwitch: UISwitch = {
        let swt = UISwitch()
        swt.onTintColor = OddsColor.primaryButtonColor
        return swt
    }()

    private let termsLabel: BaseLabel = {
        let label = BaseLabel(
            text:  "register_privacy".localized,
            font: .systemFont(ofSize: 12),
            color: OddsColor.primaryLabelColor
        )
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private let registerButton: BaseButton = {
        let btn = BaseButton(title: "general_register".localized)
        btn.setEnabled(false)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let errorLabel: BaseLabel = {
        let lbl = BaseLabel(color: OddsColor.errorColor)
        lbl.numberOfLines = 0
        lbl.isHidden = true
        return lbl
    }()

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
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasswordField)

        let termsStack = UIStackView(arrangedSubviews: [termsSwitch, termsLabel])
        termsStack.axis = .horizontal
        termsStack.spacing = 8
        termsStack.alignment = .center
        stackView.addArrangedSubview(termsStack)

        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(errorLabel)

        addSubview(stackView)
        
        registerButton.setHeight(50)

        fitSpecificLocation(subView: stackView, anchors: [
            .left(leftAnchor, 24),
            .right(rightAnchor, -24),
            .centerY(centerYAnchor)
        ])
    }

    private func setupActions() {
        nameField.onTextChanged = { [weak self] text in
            self?.nameChangedPublisher.send(text)
        }

        emailField.onTextChanged = { [weak self] text in
            self?.emailChangedPublisher.send(text)
        }

        passwordField.onTextChanged = { [weak self] text in
            self?.passwordChangedPublisher.send(text)
        }

        confirmPasswordField.onTextChanged = { [weak self] text in
            self?.confirmPasswordChangedPublisher.send(text)
        }

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        termsSwitch.addTarget(self, action: #selector(termsSwitchChanged), for: .valueChanged)
    }
    
    // MARK: - Public Interface

    func showNameError(_ message: String?) {
        nameField.setError(message)
    }

    func showMailError(_ message: String?) {
        emailField.setError(message)
    }

    func showPasswordError(_ message: String?) {
        passwordField.setError(message)
    }

    func showConfirmPasswordError(_ message: String?) {
        confirmPasswordField.setError(message)
    }

    func showGeneralError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
     
    func setRegisterButtonEnabled(_ isEnabled: Bool) {
        registerButton.setEnabled(isEnabled)
    }
    
    // MARK: - Button actions

    @objc private func registerTapped() {
        registerTappedPublisher.send()
    }

    @objc private func termsSwitchChanged() {
        termsAcceptedPublisher.send(termsSwitch.isOn)
    }
}
