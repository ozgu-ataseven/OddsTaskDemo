//
//  RegisterViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 16.05.2025.
//
 
import Foundation
import Combine

final class RegisterViewModel: RegisterViewModelProtocol {
    
    private let authService: AuthenticationServiceProtocol
    private let routeSportListSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Public Properties
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var acceptedTerms: Bool = false

    // MARK: - Private Properties
    @Published private(set) var emailValidationMessage: String? = nil
    @Published private(set) var passwordValidationMessage: String? = nil
    @Published private(set) var confirmPasswordValidationMessage: String? = nil
    @Published private(set) var nameValidationMessage: String? = nil
    @Published private(set) var isFormValid: Bool = false
    @Published private var isLoading: Bool = false
    @Published private var alert: Alert?
    
    // MARK: - RegisterViewModelProtocol Publishers
    var emailValidationMessagePublisher: AnyPublisher<String?, Never> {
        $emailValidationMessage.eraseToAnyPublisher()
    }
    var passwordValidationMessagePublisher: AnyPublisher<String?, Never> {
        $passwordValidationMessage.eraseToAnyPublisher()
    }
    var confirmPasswordValidationMessagePublisher: AnyPublisher<String?, Never> {
        $confirmPasswordValidationMessage.eraseToAnyPublisher()
    }
    var nameValidationMessagePublisher: AnyPublisher<String?, Never> {
        $nameValidationMessage.eraseToAnyPublisher()
    }
    
    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        $isFormValid.eraseToAnyPublisher()
    }
    
    var routeSportListPublisher: AnyPublisher<Void, Never> {
        routeSportListSubject.eraseToAnyPublisher()
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var alertPublisher: AnyPublisher<Alert, Never> {
        $alert.compactMap { $0 }.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    
    init(authService: AuthenticationServiceProtocol) {
        self.authService = authService
        setupValidation()
    }
    
    // MARK: - Public Methods
    func register() {
        isLoading = true

        authService.register(email: email, password: password) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success:
                self?.routeSportListSubject.send()
            case .failure(let error):
                handleError(error)
            }
        }
        
        func handleError(_ error: Error) {
            let firebaseMessage = error.localizedDescription.lowercased()
            
            let readableMessage: String
            if firebaseMessage.contains("email") && firebaseMessage.contains("already") {
                readableMessage = "Bu email adresi zaten kayıtlı."
            } else if firebaseMessage.contains("network") {
                readableMessage = "İnternet bağlantınızı kontrol edin."
            } else {
                readableMessage = error.localizedDescription
            }
            
            alert = Alert(
                title: "Kayıt Başarısız",
                message: readableMessage,
                actions: [.init(title: "Tamam")]
            )
        }
    }
    
    // MARK: - Private Methods
    private func updateFormValidity(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        acceptedTerms: Bool
    ) {
        let isValid = validateName(name) == nil &&
                      validateEmail(email) == nil &&
                      validatePassword(password) == nil &&
                      validateConfirmPassword(confirmPassword, original: password) == nil &&
                      acceptedTerms

        isFormValid = isValid
    }
    
    private func setupValidation() {
        Publishers.CombineLatest4($name, $email, $password, $acceptedTerms)
            .dropFirst()
            .combineLatest($confirmPassword)
            .sink { [weak self] values, confirmPassword in
                guard let self else { return }
                let (name, email, password, acceptedTerms) = values
                self.updateFormValidity(
                    name: name,
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword,
                    acceptedTerms: acceptedTerms
                )
            }
            .store(in: &cancellables)

        $email
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { [weak self] in self?.validateEmail($0) }
            .assign(to: &$emailValidationMessage)

        $password
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { [weak self] in self?.validatePassword($0) }
            .assign(to: &$passwordValidationMessage)

        Publishers.CombineLatest($confirmPassword, $password)
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { [weak self] confirm, password in
                self?.validateConfirmPassword(confirm, original: password)
            }
            .assign(to: &$confirmPasswordValidationMessage)

        $name
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { [weak self] in self?.validateName($0) }
            .assign(to: &$nameValidationMessage)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Validators
fileprivate extension RegisterViewModel {
    
    func validateName(_ name: String) -> String? {
        let error = name.isEmpty ? "register_empty_name".localized : nil
        return error
    }

    func validateEmail(_ email: String) -> String? {
        if email.isEmpty { return "general_empty_mail".localized }
        let error = email.isValidEmail ? nil : "general_invalid_mail".localized
        return error
    }

    func validatePassword(_ password: String) -> String? {
        let error = password.count < 6 ? "Şifre en az 6 karakter olmalı." : nil
        return error
    }

    func validateConfirmPassword(_ confirmPassword: String, original: String) -> String? {
        let error = confirmPassword != original ? "register_password_failed".localized : nil
        return error
    }
}
