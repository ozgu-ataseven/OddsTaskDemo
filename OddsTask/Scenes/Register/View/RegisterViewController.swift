//
//  RegisterViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 16.05.2025.
//

import UIKit
import Combine

final class RegisterViewController: BaseViewController<RegisterView> {

    private let viewModel: RegisterViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: RegisterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kayıt Ol"
        bindViewModel()
        bindView()
    }
    
    // MARK: - Combine Bindings
    
    private func bindView() {
        rootView.nameChangedPublisher
            .sink { [weak self] in self?.viewModel.name = $0 }
            .store(in: &cancellables)

        rootView.emailChangedPublisher
            .sink { [weak self] in self?.viewModel.email = $0 }
            .store(in: &cancellables)

        rootView.passwordChangedPublisher
            .sink { [weak self] in self?.viewModel.password = $0 }
            .store(in: &cancellables)

        rootView.confirmPasswordChangedPublisher
            .sink { [weak self] in self?.viewModel.confirmPassword = $0 }
            .store(in: &cancellables)

        rootView.termsAcceptedPublisher
            .sink { [weak self] in self?.viewModel.acceptedTerms = $0 }
            .store(in: &cancellables)

        rootView.registerTappedPublisher
            .sink { [weak self] in self?.viewModel.register() }
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.nameValidationMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.rootView.showNameError(message)
            }
            .store(in: &cancellables)
        
        viewModel.emailValidationMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.rootView.showMailError(message)
            }
            .store(in: &cancellables)

        viewModel.passwordValidationMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.rootView.showPasswordError(message)
            }
            .store(in: &cancellables)
        
        viewModel.confirmPasswordValidationMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.rootView.showConfirmPasswordError(message)
            }
            .store(in: &cancellables)

        viewModel.isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isValid in
                self?.rootView.setRegisterButtonEnabled(isValid)
            }
            .store(in: &cancellables)
        
        viewModel.routeSportListPublisher
            .sink {
                AppRouter.shared.setRoot(for: .sportList)
            }
            .store(in: &cancellables)
        
        viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? ProgressView.show(on: self.view) : ProgressView.hide()
            }
            .store(in: &cancellables)
        
        viewModel.alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                self?.showAlert(alert)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
