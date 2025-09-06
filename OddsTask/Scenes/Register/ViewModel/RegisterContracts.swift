//
//  RegisterContracts.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import Combine

protocol RegisterViewModelProtocol: AnyObject {

    // MARK: - Inputs
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    var acceptedTerms: Bool { get set }
    
    // MARK: - Outputs
    var nameValidationMessagePublisher: AnyPublisher<String?, Never> { get }
    var emailValidationMessagePublisher: AnyPublisher<String?, Never> { get }
    var passwordValidationMessagePublisher: AnyPublisher<String?, Never> { get }
    var confirmPasswordValidationMessagePublisher: AnyPublisher<String?, Never> { get }
    var isFormValidPublisher: AnyPublisher<Bool, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var alertPublisher: AnyPublisher<Alert, Never> { get }
    var routeSportListPublisher: AnyPublisher<Void, Never> { get }
    var routeLoginPublisher: AnyPublisher<Void, Never> { get }
    
    // MARK: - Actions
    func register()
}
