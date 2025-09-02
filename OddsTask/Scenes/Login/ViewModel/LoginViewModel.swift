//
//  LoginViewModel.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 16.05.2025.
//

import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private let authService: AuthenticationServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    private let routeSportListSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Public Properties
    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - Private Properties
    @Published private var emailValidationMessage: String?
    @Published private var passwordValidationMessage: String?
    @Published private var isFormValid: Bool = false
    @Published private var isLoading: Bool = false
    @Published private var alert: Alert?
    
    var routeSportListPublisher: AnyPublisher<Void, Never> {
        routeSportListSubject.eraseToAnyPublisher()
    }

    // MARK: - LoginViewModelProtocol Publishers
    var emailValidationMessagePublisher: AnyPublisher<String?, Never> {
        $emailValidationMessage.eraseToAnyPublisher()
    }

    var passwordValidationMessagePublisher: AnyPublisher<String?, Never> {
        $passwordValidationMessage.eraseToAnyPublisher()
    }

    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        $isFormValid.eraseToAnyPublisher()
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var alertPublisher: AnyPublisher<Alert, Never> {
        $alert.compactMap { $0 }.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    init(authService: AuthenticationServiceProtocol, analyticsService: AnalyticsServiceProtocol) {
        self.authService = authService
        self.analyticsService = analyticsService
        setupValidation()
    }

    // MARK: - Public Methods
    func login() {
        analyticsService.logEvent(name: AnalyticsEvent.Action.loginTapped, parameters: nil)
        isLoading = true

        guard !email.isEmpty, !password.isEmpty else {
            isLoading = false
            alert = Alert(
                title: "Hata",
                message: "Email ve şifre boş olamaz",
                actions: [
                    .init(title: "Tamam")
                ]
            )
            return
        }
        
        authService.login(email: email, password: password) { [weak self] result in
            self?.isLoading = true
            switch result {
            case .success:
                self?.routeSportListSubject.send()
            case .failure(let error):
                self?.alert = Alert(title: "Hata", message: error.localizedDescription, actions: [.init(title: "Tamam")])
            }
        }
    }
    
    func registerTapped() {
        analyticsService.logEvent(name: AnalyticsEvent.Action.registerTapped, parameters: nil)
    }

    // MARK: - Private Methods
    private func setupValidation() {
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

        Publishers.CombineLatest($email, $password)
            .map { [weak self] email, password in
                guard let self else { return false }
                return self.validateEmail(email) == nil &&
                       self.validatePassword(password) == nil &&
                       !email.isEmpty &&
                       !password.isEmpty
            }
            .removeDuplicates()
            .assign(to: &$isFormValid)
    }
}

// MARK: - Validators
fileprivate extension LoginViewModel {
    
    func validateEmail(_ email: String) -> String? {
        if email.isEmpty { return "Email boş olamaz." }
        let error = email.isValidEmail ? nil : "Geçerli bir email değil."
        return error
    }
    
    private func validatePassword(_ password: String) -> String? {
        return password.count < 6 ? "Şifre en az 6 karakter olmalı" : nil
    }
}
