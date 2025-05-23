//
//  BaseTextField.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

final class BaseTextField: UIView {
    
    var onTextChanged: ((String) -> Void)?

    // MARK: - UI Elements

    private let textField = UITextField()
    private let floatingLabel = UILabel()
    private let errorLabel = UILabel()
    private let containerView = UIView()

    // MARK: - Properties

    private var placeholderText: String = ""
    private let floatingLabelFont: UIFont = .systemFont(ofSize: 11, weight: .medium)
    private let textFieldFont: UIFont = .systemFont(ofSize: 15)

    // MARK: - Public API

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var placeholder: String? {
        get { placeholderText }
        set {
            placeholderText = newValue ?? ""
            textField.placeholder = placeholderText
            floatingLabel.text = placeholderText
        }
    }

    func setError(_ message: String?) {
        if let message, !message.isEmpty {
            errorLabel.text = message
            errorLabel.isHidden = false
            containerView.layer.borderColor = OddsColor.errorColor.cgColor
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            containerView.layer.borderColor = isFirstResponder ? OddsColor.activeFieldBorder.cgColor :  OddsColor.fieldBorder.cgColor
        }
    }

    // MARK: - Init

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear

        // Container
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor =  OddsColor.fieldBorder.cgColor
        containerView.backgroundColor =  OddsColor.fieldBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        // Floating Label
        floatingLabel.font = floatingLabelFont
        floatingLabel.textColor = OddsColor.secondayLabelColor
        floatingLabel.alpha = 0
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(floatingLabel)

        // Text Field
        textField.font = textFieldFont
        textField.textColor = OddsColor.primaryLabelColor
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentVerticalAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: UIColor(hex: "#888888")]
        )
        containerView.addSubview(textField)

        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        // Error Label
        errorLabel.font = .systemFont(ofSize: 11)
        errorLabel.textColor =  OddsColor.errorColor
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),

            floatingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            floatingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),

            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 22),

            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - State

    @objc private func editingDidBegin() {
        animateFloatingLabel(up: true)
        textField.placeholder = ""
        if errorLabel.isHidden {
            containerView.layer.borderColor = OddsColor.activeFieldBorder.cgColor
        }
    }

    @objc private func editingDidEnd() {
        let hasText = !(textField.text ?? "").isEmpty
        animateFloatingLabel(up: hasText)
        textField.placeholder = hasText ? "" : placeholderText
        if errorLabel.isHidden {
            containerView.layer.borderColor = OddsColor.fieldBorder.cgColor
        }
    }
    
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }

    private func animateFloatingLabel(up: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.alpha = up ? 1 : 0
        }
    }
}
