//
//  LoginViewController.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 16.05.2025.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController<LoginView> {

    // MARK: - Properties

    private let viewModel: LoginViewModelProtocol
    private unowned let router: RouterProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(viewModel: LoginViewModelProtocol, router: RouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        bindViewModel()
        bindView()
    }

    // MARK: - Bindings

    private func bindView() {
        rootView.loginTappedPublisher
            .sink { [weak self] in
                self?.viewModel.login()
            }
            .store(in: &cancellables)

        rootView.registerTappedPublisher
            .sink { [weak self] in
                guard let self else { return }
                router.push(.register, from: self, animated: true)
                viewModel.registerTapped()
            }
            .store(in: &cancellables)

        rootView.emailChangedPublisher
            .sink { [weak self] in
                self?.viewModel.email = $0
            }
            .store(in: &cancellables)

        rootView.passwordChangedPublisher
            .sink { [weak self] in
                self?.viewModel.password = $0
            }
            .store(in: &cancellables)
    }

    private func bindViewModel() {
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

        viewModel.isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isValid in
                self?.rootView.setLoginButton(enabled: isValid)
            }
            .store(in: &cancellables)
        
        viewModel.routeSportListPublisher
            .sink { [weak self] in
                self?.router.setRoot(for: .sportList, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.loadingPublisher
            .dropFirst()
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
