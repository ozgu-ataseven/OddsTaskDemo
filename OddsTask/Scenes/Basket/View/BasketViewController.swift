//
//  BasketViewcontroller.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//
 
import UIKit
import Combine

final class BasketViewController: BaseViewController<BasketView> {

    private let viewModel: BasketViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: BasketViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sepet"
        rootView.setDelegate(self)
        bindViewModel()
        bindView()
        viewModel.fetchBasketItems()
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.itemsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.rootView.updateItems(items)
            }
            .store(in: &cancellables)

        viewModel.totalPricePublisher
            .receive(on: RunLoop.main)
            .sink { total in
                print("Toplam fiyat: \(total)₺")
            }
            .store(in: &cancellables)

        viewModel.alertPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] alert in
                self?.showAlert(alert)
            }
            .store(in: &cancellables)
        
        viewModel.totalPricePublisher
            .combineLatest(viewModel.totalAmountPublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] total, amount in
                self?.rootView.updateTotalPrice(total, amount: amount)
            }
            .store(in: &cancellables)
        
        viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? ProgressView.show(on: self.view) : ProgressView.hide()
            }
            .store(in: &cancellables)
    }

    private func bindView() {
        rootView.closeTappedPublisher
            .sink {
                AppRouter.shared.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        rootView.clearAllTappedPublisher
            .sink { [weak self] in
                self?.viewModel.clearBasket()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completion) in
            guard let self,
                  let item = self.rootView.item(at: indexPath) else {
                completion(false)
                return
            }

            self.viewModel.removeItem(withId: item.id)
            self.rootView.deleteRow(at: indexPath)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
